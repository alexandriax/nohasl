import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash, webcrypto } from 'node:crypto';
import { RuntimeCache } from '../src/runtime_cache.js';

function fixture() {
  const entries = new Map();
  const storage = { open: async (scope) => ({
    match: async (url) => entries.get(`${scope}:${url}`)?.clone(),
    put: async (url, response) => entries.set(`${scope}:${url}`, response.clone()),
  }) };
  const source = 'self.onmessage = () => {};';
  const bytes = Buffer.from(source);
  const options = {
    url: 'https://app.example/learn/local_models/worker-new.js',
    bytes: bytes.byteLength, hash: createHash('sha256').update(bytes).digest('hex'),
    storage, crypto: webcrypto,
  };
  return { entries, storage, source, options };
}

test('explicit Use after an app update installs only the new app worker, keeping model files untouched', async () => {
  const { entries, storage, source, options } = fixture();
  await (await storage.open('webllm/model')).put('https://models.example/weights', new Response('saved model'));
  await (await storage.open('nohasl/local-model-runtime-v1')).put('https://app.example/learn/local_models/worker-old.js', new Response('old app runtime'));
  const requests = [];
  const runtime = new RuntimeCache({ ...options, fetchFile: async (url) => {
    requests.push(url);
    return new Response(source);
  } });
  await assert.rejects(runtime.source(), { code: 'runtimeUpdateRequired' });
  assert.equal(requests.length, 0, 'inventory/implicit access must not install an update');
  assert.equal(await runtime.source({ allowInstall: true }), source);
  assert.deepEqual(requests, [options.url]);
  assert.equal(await entries.get('webllm/model:https://models.example/weights').text(), 'saved model');
  assert.ok(entries.has('nohasl/local-model-runtime-v1:https://app.example/learn/local_models/worker-old.js'));
});

test('updated runtime resumes entirely offline after its first explicit install', async () => {
  const { source, options } = fixture();
  let requests = 0;
  const online = new RuntimeCache({ ...options, fetchFile: async () => {
    requests++;
    return new Response(source);
  } });
  await online.source({ allowInstall: true });
  const offline = new RuntimeCache({ ...options, fetchFile: async () => assert.fail('no script fetch on cached load') });
  assert.equal(await offline.source({ allowInstall: true }), source);
  assert.equal(await offline.source(), source);
  assert.equal(requests, 1);
});

test('offline app update gives a reconnect-once error without touching saved models', async () => {
  const { entries, storage, options } = fixture();
  await (await storage.open('webllm/model')).put('https://models.example/weights', new Response('saved model'));
  const runtime = new RuntimeCache({ ...options, fetchFile: async () => { throw new TypeError('offline'); } });
  await assert.rejects(runtime.source({ allowInstall: true }), (cause) => {
    assert.equal(cause.code, 'runtimeUpdateRequired');
    assert.match(cause.message, /Connect once/);
    assert.match(cause.message, /downloaded model files are preserved/);
    return true;
  });
  assert.equal(entries.size, 1);
});

test('mismatched or truncated app runtime is not cached as an installed update', async () => {
  const { entries, options } = fixture();
  const runtime = new RuntimeCache({ ...options, fetchFile: async () => new Response('wrong script') });
  await assert.rejects(runtime.source({ allowInstall: true }), { code: 'runtimeMissing' });
  assert.equal(entries.size, 0);
});
