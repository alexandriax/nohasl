import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash, webcrypto } from 'node:crypto';
import { cachedModelIds, deleteModelArtifacts, downloadModelArtifacts,
  isModelCached, probeSupport, validateGeneration, validateResponse } from '../src/cache.js';
import { boundedResponseSchema, rollbackModelDownload } from '../src/cache.js';
import { models } from '../src/catalog.js';
import { installCacheOnlyNetworkGuard } from '../src/network_guard.js';

class MemoryCacheStorage {
  entries = new Map();
  async open(scope) {
    if (!this.entries.has(scope)) this.entries.set(scope, new Map());
    const entries = this.entries.get(scope);
    return {
      match: async (url) => entries.get(typeof url === 'string' ? url : url.url)?.clone(),
      put: async (url, response) => { entries.set(url, new Response(await response.arrayBuffer(), { headers: response.headers })); },
      delete: async (url) => entries.delete(url),
    };
  }
}

function fixture(id = 'model-a') {
  const artifacts = ['mlc-chat-config.json', 'tensor-cache.json', 'params_shard_0.bin', 'tokenizer.json', 'runtime.wasm'].map((path, index) => {
    const bytes = new Uint8Array([index, 2, 5, 8]);
    return {
      path, url: `https://models.example/${id}/${path}`,
      scope: path === 'mlc-chat-config.json' ? 'webllm/config' : path.endsWith('.wasm') ? 'webllm/wasm' : 'webllm/model',
      bytes: bytes.byteLength,
      hash: createHash('sha256').update(bytes).digest('hex'), hashAlgorithm: 'sha256', data: bytes,
    };
  });
  return { id, artifacts, downloadBytes: 20 };
}

async function populate(model, storage, options = {}) {
  await downloadModelArtifacts(model, {
    storage, crypto: webcrypto,
    fetchFile: async (url) => new Response(model.artifacts.find((artifact) => artifact.url === url).data),
    ...options,
  });
}

test('pinned catalog sizes include configuration, tokenizer, manifest, weights, and matching WASM', () => {
  assert.equal(models.length, 2);
  assert.deepEqual(models.map((model) => model.downloadBytes), [211553449, 1493768395]);
  for (const model of models) {
    assert.match(model.revision, /^[a-f0-9]{40}$/);
    assert.equal(model.downloadBytes, model.artifacts.reduce((sum, artifact) => sum + artifact.bytes, 0));
    assert.ok(model.artifacts.some((artifact) => artifact.path === 'tokenizer.json'));
    assert.ok(model.artifacts.some((artifact) => artifact.path === 'mlc-chat-config.json'));
    assert.ok(model.artifacts.some((artifact) => artifact.path === 'tensor-cache.json'));
    assert.ok(model.artifacts.some((artifact) => artifact.url === model.model_lib));
    assert.ok(!model.artifacts.some((artifact) => artifact.url.includes('/main/')));
    assert.equal(new Set(model.artifacts.map((artifact) => artifact.url)).size, model.artifacts.length);
    for (const artifact of model.artifacts) {
      assert.ok(artifact.bytes > 0);
      assert.match(artifact.hash, artifact.hashAlgorithm === 'sha256' ? /^[a-f0-9]{64}$/ : /^[a-f0-9]{40}$/);
    }
  }
  assert.equal(models[0].license, 'apache-2.0');
  assert.equal(models[1].license, 'Gemma Terms of Use');
  assert.ok(models[1].termsNotice.length > 50);
});

test('only complete verified downloads count; a cached weight shard alone is insufficient', async () => {
  const storage = new MemoryCacheStorage();
  const model = fixture();
  const updates = [];
  await populate(model, storage, { onProgress: (value) => updates.push(value) });
  assert.equal(await isModelCached(model, storage), true);
  assert.deepEqual(await cachedModelIds([model], storage), [model.id]);
  assert.equal(updates.at(-1).downloadedBytes, 20);
  assert.equal(updates.at(-1).fraction, 1);
  const config = model.artifacts[0];
  await (await storage.open(config.scope)).delete(config.url);
  assert.equal(await isModelCached(model, storage), false);
  assert.deepEqual(await cachedModelIds([model], storage), []);
});

test('low-level interrupted fetch can reuse verified files before transaction rollback', async () => {
  const storage = new MemoryCacheStorage();
  const model = fixture();
  const controller = new AbortController();
  const fetched = [];
  await assert.rejects(populate(model, storage, {
    signal: controller.signal,
    fetchFile: async (url) => {
      fetched.push(url);
      if (fetched.length === 2) controller.abort();
      return new Response(model.artifacts.find((artifact) => artifact.url === url).data);
    },
  }), { name: 'AbortError' });
  assert.equal(await isModelCached(model, storage), false);
  const retry = [];
  await populate(model, storage, {
    fetchFile: async (url) => {
      retry.push(url);
      return new Response(model.artifacts.find((artifact) => artifact.url === url).data);
    },
  });
  assert.equal(retry.length, 4);
  assert.ok(!retry.includes(model.artifacts[0].url));
  assert.equal(await isModelCached(model, storage), true);
});

test('wrong bytes, truncated responses, and unverified raw cache entries are never installed', async () => {
  for (const data of [new Uint8Array([9, 9, 9, 9]), new Uint8Array([0])]) {
    const storage = new MemoryCacheStorage();
    const model = fixture();
    await assert.rejects(populate(model, storage, { fetchFile: async () => new Response(data) }), { code: 'invalidDownload' });
    assert.equal(await isModelCached(model, storage), false);
  }
  const storage = new MemoryCacheStorage();
  const model = fixture();
  for (const artifact of model.artifacts) {
    await (await storage.open(artifact.scope)).put(artifact.url, new Response(artifact.data));
  }
  assert.equal(await isModelCached(model, storage), false);
});

test('git blob digests verify config and compiled WASM artifacts too', async () => {
  const storage = new MemoryCacheStorage();
  const model = fixture();
  for (const artifact of model.artifacts) {
    artifact.hashAlgorithm = 'git-sha1';
    artifact.hash = createHash('sha1').update(`blob ${artifact.bytes}\0`).update(artifact.data).digest('hex');
  }
  await populate(model, storage);
  assert.equal(await isModelCached(model, storage), true);
});

test('remove is offline and deletes selected files without disturbing another model or app data', async () => {
  const storage = new MemoryCacheStorage();
  const first = fixture('first');
  const second = fixture('second');
  await populate(first, storage);
  await populate(second, storage);
  await (await storage.open('learning-progress')).put('/progress', new Response('keep'));
  await (await storage.open('webllm/model')).put('https://other.example/model', new Response('keep'));
  await deleteModelArtifacts(first, [first, second], storage);
  assert.equal(await isModelCached(first, storage), false);
  assert.equal(await isModelCached(second, storage), true);
  assert.equal(await (await (await storage.open('learning-progress')).match('/progress')).text(), 'keep');
  assert.equal(await (await (await storage.open('webllm/model')).match('https://other.example/model')).text(), 'keep');
});

test('failed or canceled download cleanup stops writes and removes only its partial artifacts', async () => {
  const storage = new MemoryCacheStorage();
  const selected = fixture('partial');
  const other = fixture('complete');
  await populate(other, storage);
  await (await storage.open('nohasl/local-model-runtime-v1')).put('/worker.js', new Response('shared runtime'));
  const controller = new AbortController();
  let files = 0;
  await assert.rejects(populate(selected, storage, {
    signal: controller.signal,
    fetchFile: async (url) => {
      if (++files === 3) controller.abort();
      return new Response(selected.artifacts.find((artifact) => artifact.url === url).data);
    },
  }), { name: 'AbortError' });
  let stopped = false;
  const orderedStorage = { open: async (scope) => {
    const cache = await storage.open(scope);
    return { ...cache, delete: async (url) => { assert.equal(stopped, true); return cache.delete(url); } };
  } };
  await rollbackModelDownload(selected, [selected, other], {
    stopWorker: () => { stopped = true; }, storage: orderedStorage,
  });
  for (const artifact of selected.artifacts) {
    assert.equal(await (await storage.open(artifact.scope)).match(artifact.url), undefined);
  }
  assert.equal(await isModelCached(other, storage), true);
  assert.equal(await (await (await storage.open('nohasl/local-model-runtime-v1')).match('/worker.js')).text(), 'shared runtime');
});

test('a failed runtime refresh does not remove a model that was complete before the operation', async () => {
  const storage = new MemoryCacheStorage();
  const model = fixture();
  await populate(model, storage);
  await rollbackModelDownload(model, [model], {
    stopWorker: () => {}, wasCompleteBefore: true, storage,
  });
  assert.equal(await isModelCached(model, storage), true);
});

test('capability probe checks shader-f16 and storage without requesting model data', async () => {
  const env = {
    isSecureContext: true, caches: {}, Worker: class {}, crypto: webcrypto,
    navigator: { gpu: { requestAdapter: async () => ({ features: new Set(['shader-f16']) }) },
      storage: { estimate: async () => ({ quota: 1000, usage: 400 }) } },
    fetch: () => assert.fail('probe must not fetch'),
  };
  assert.deepEqual(await probeSupport(env), {
    available: true, reason: 'Local text models are available. Downloads stay in this browser’s storage.', availableStorageBytes: 600,
  });
  env.navigator.gpu.requestAdapter = async () => ({ features: new Set() });
  assert.equal((await probeSupport(env)).available, false);
  env.navigator.gpu = null;
  assert.equal((await probeSupport(env)).available, false);
});

test('cached inference cannot fetch through either fetch or Cache.add, while explicit download can', async () => {
  let requests = 0;
  class WorkerCache {
    async add() { requests++; }
    async addAll() { requests++; }
    async put() { return 'local write'; }
  }
  const scope = { fetch: async () => { requests++; return new Response('download'); }, Cache: WorkerCache };
  const downloadFetch = installCacheOnlyNetworkGuard(scope);
  await assert.rejects(scope.fetch('https://models.example/missing'), { code: 'missingCache' });
  await assert.rejects(new WorkerCache().add('https://models.example/missing'), { code: 'missingCache' });
  await assert.rejects(new WorkerCache().addAll(['https://models.example/missing']), { code: 'missingCache' });
  assert.equal(requests, 0);
  assert.equal(await new WorkerCache().put(), 'local write');
  await downloadFetch('https://models.example/explicit');
  assert.equal(requests, 1);
});

const fields = ['reply', 'followUpQuestion', 'suggestedReply', 'practiceGoal'];
const schema = { type: 'object', properties: Object.fromEntries(fields.map((key) => [key, { type: 'string' }])), required: fields, additionalProperties: false };
const reply = Object.fromEntries(fields.map((field) => [field, 'A short idea.']));

test('structured output rejects truncation, extras, missing fields, wrong types and excessive text', () => {
  assert.deepEqual(JSON.parse(validateResponse(JSON.stringify(reply), 'stop')), reply);
  for (const value of [{ ...reply, extra: true }, { ...reply, reply: '' }, { ...reply, reply: 4 }, { ...reply, reply: 'word '.repeat(201) }, ['hello']]) {
    assert.throws(() => validateResponse(JSON.stringify(value), 'stop'), { code: 'invalidResponse' });
  }
  assert.throws(() => validateResponse(JSON.stringify(reply), 'length'), { code: 'invalidResponse' });
  assert.throws(() => validateResponse('```json\n' + JSON.stringify(reply) + '\n```', 'stop'), { code: 'invalidResponse' });
  assert.throws(() => validateResponse('{"reply":', 'stop'), { code: 'invalidResponse' });
  validateGeneration([{ role: 'system', content: 'Bounded instructions' }, { role: 'user', content: 'Bounded data' }], schema);
  assert.throws(() => validateGeneration([{ role: 'user', content: 'x'.repeat(10001) }], schema), { code: 'invalidInput' });
  assert.throws(() => validateGeneration([{ role: 'system', content: 'x' }, { role: 'user', content: 'y' }], { ...schema, additionalProperties: true }), { code: 'invalidInput' });
  assert.throws(() => validateResponse(JSON.stringify({ ...reply, reply: 'x'.repeat(241) }), 'stop'), { code: 'invalidResponse' });
  assert.throws(() => validateResponse(JSON.stringify({ ...reply, suggestedReply: 'x'.repeat(161) }), 'stop'), { code: 'invalidResponse' });
  const bounded = boundedResponseSchema(schema);
  assert.equal(bounded.properties.reply.maxLength, 240);
  assert.equal(bounded.properties.followUpQuestion.maxLength, 160);
  assert.equal(bounded.properties.practiceGoal.minLength, 1);
});
