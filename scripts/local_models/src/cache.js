// The engine uses these three Cache API scopes. Never delete a whole scope:
// another model (or another WebLLM feature on this origin) can share it.
export class LocalModelError extends Error {
  constructor(code, message) {
    super(message);
    this.name = 'LocalModelError';
    this.code = code;
  }
}

export const error = (code, message) => new LocalModelError(code, message);

const marker = (artifact) => `${artifact.hashAlgorithm}:${artifact.hash}`;

export async function isArtifactCached(artifact, storage = globalThis.caches) {
  if (!storage) return false;
  const cache = await storage.open(artifact.scope);
  const response = await cache.match(artifact.url);
  // Cache.put is atomic. This marker is written only after exact byte count and
  // pinned digest verification; incomplete downloads never get this marker.
  return !!response && response.ok &&
    response.headers.get('x-nohasl-verified') === marker(artifact) &&
    response.headers.get('content-length') === String(artifact.bytes);
}

export async function isModelCached(model, storage = globalThis.caches) {
  for (const artifact of model.artifacts) {
    if (!await isArtifactCached(artifact, storage)) return false;
  }
  return true;
}

export async function cachedModelIds(models, storage = globalThis.caches) {
  const ids = [];
  for (const model of models) {
    if (await isModelCached(model, storage)) ids.push(model.id);
  }
  return ids;
}

export async function deleteModelArtifacts(model, models, storage = globalThis.caches) {
  if (!storage) return;
  for (const artifact of model.artifacts) {
    // Preserve an artifact referenced by another offered release. Our current
    // two releases share none; this rule keeps future variants safe.
    const shared = models.some((other) => other.id !== model.id &&
      other.artifacts.some((candidate) => candidate.scope === artifact.scope &&
        candidate.url === artifact.url));
    if (!shared) await (await storage.open(artifact.scope)).delete(artifact.url);
  }
}

export async function rollbackModelDownload(model, models, {
  stopWorker, wasCompleteBefore = false, storage = globalThis.caches,
}) {
  // Terminate first: otherwise a late worker write could recreate a deleted
  // artifact. Cache API operations are awaited before inventory is refreshed.
  stopWorker();
  if (!await wasCompleteBefore) await deleteModelArtifacts(model, models, storage);
}

async function verifyBytes(bytes, artifact, crypto = globalThis.crypto) {
  if (bytes.byteLength !== artifact.bytes) {
    throw error('invalidDownload', 'A model file was incomplete. Download again to retry that file.');
  }
  let input = bytes;
  let algorithm = 'SHA-256';
  if (artifact.hashAlgorithm === 'git-sha1') {
    algorithm = 'SHA-1';
    const prefix = new TextEncoder().encode(`blob ${bytes.byteLength}\0`);
    input = new Uint8Array(prefix.byteLength + bytes.byteLength);
    input.set(prefix);
    input.set(bytes, prefix.byteLength);
  }
  const digest = new Uint8Array(await crypto.subtle.digest(algorithm, input));
  const hex = Array.from(digest, (part) => part.toString(16).padStart(2, '0')).join('');
  if (hex !== artifact.hash) {
    throw error('invalidDownload', 'A model file did not match its pinned release. Please retry the download.');
  }
}

export async function downloadModelArtifacts(model, {
  storage = globalThis.caches,
  fetchFile = globalThis.fetch.bind(globalThis),
  crypto = globalThis.crypto,
  signal,
  onProgress = () => {},
} = {}) {
  let downloadedBytes = 0;
  const totalBytes = model.downloadBytes;
  const report = (message) => onProgress({
    message, downloadedBytes, totalBytes,
    fraction: Math.min(1, downloadedBytes / totalBytes),
  });
  const remaining = [];
  for (const artifact of model.artifacts) {
    signal?.throwIfAborted();
    if (await isArtifactCached(artifact, storage)) downloadedBytes += artifact.bytes;
    else remaining.push(artifact);
  }
  report(remaining.length ? 'Downloading model files…' : 'All model files are already downloaded.');
  // One file at a time bounds memory. Partial individual files are retried from
  // the beginning; completed, verified files are reused after cancellation.
  for (const artifact of remaining) {
    signal?.throwIfAborted();
    const response = await fetchFile(artifact.url, {
      signal, credentials: 'omit', cache: 'no-store', redirect: 'follow',
    });
    if (!response.ok || !response.body) {
      throw error('downloadFailed', `Could not download ${artifact.path}. Check your connection and retry.`);
    }
    const reader = response.body.getReader();
    const bytes = new Uint8Array(artifact.bytes);
    let offset = 0;
    try {
      while (true) {
        signal?.throwIfAborted();
        const { done, value } = await reader.read();
        if (done) break;
        if (offset + value.byteLength > artifact.bytes) {
          throw error('invalidDownload', 'A model file exceeded its expected size. Please retry.');
        }
        bytes.set(value, offset);
        offset += value.byteLength;
        downloadedBytes += value.byteLength;
        report(`Downloading ${artifact.path}…`);
      }
    } catch (cause) {
      await reader.cancel().catch(() => {});
      throw cause;
    } finally {
      reader.releaseLock();
    }
    if (offset !== artifact.bytes) throw error('invalidDownload', 'A model download ended early. Please retry.');
    signal?.throwIfAborted();
    report(`Verifying ${artifact.path}…`);
    await verifyBytes(bytes, artifact, crypto);
    signal?.throwIfAborted();
    const cache = await storage.open(artifact.scope);
    await cache.put(artifact.url, new Response(bytes, { headers: {
      'content-type': artifact.path.endsWith('.json') ? 'application/json' : 'application/octet-stream',
      'content-length': String(artifact.bytes),
      'x-nohasl-verified': marker(artifact),
    } }));
  }
  signal?.throwIfAborted();
  if (!await isModelCached(model, storage)) {
    throw error('storageEvicted', 'Browser storage removed a model file. Free some storage and retry the download.');
  }
  report('Download complete. Ready to load on this browser.');
}

export async function probeSupport(env = globalThis) {
  let availableStorageBytes;
  try {
    const estimate = await env.navigator?.storage?.estimate?.();
    if (Number.isFinite(estimate?.quota) && Number.isFinite(estimate?.usage)) {
      availableStorageBytes = Math.max(0, estimate.quota - estimate.usage);
    }
  } catch { /* Storage estimates are optional and can be unavailable. */ }
  const result = (available, reason) => ({ available, reason, availableStorageBytes });
  if (!env.isSecureContext) return result(false, 'Local browser models require HTTPS or localhost.');
  if (!env.caches || !env.crypto?.subtle || !env.Worker) {
    return result(false, 'This browser does not provide the worker or storage features needed for local models.');
  }
  if (!env.navigator?.gpu) return result(false, 'WebGPU is unavailable. Try a browser with WebGPU enabled.');
  try {
    const adapter = await env.navigator.gpu.requestAdapter();
    if (!adapter) return result(false, 'This browser could not access a WebGPU graphics adapter.');
    if (!adapter.features.has('shader-f16')) {
      return result(false, 'These compact models need WebGPU shader-f16, which this graphics adapter does not support.');
    }
    // This only confirms capability; neither VRAM nor free system memory is
    // exposed reliably by WebGPU. Model allocation can still fail at load time.
    return result(true, 'Local text models are available. Downloads stay in this browser’s storage.');
  } catch {
    return result(false, 'WebGPU could not be initialized. Enable graphics acceleration or try another browser.');
  }
}

export function validateGeneration(messages, schema) {
  const fields = ['reply', 'followUpQuestion', 'suggestedReply', 'practiceGoal'];
  if (!Array.isArray(messages) || messages.length !== 2 ||
      messages[0]?.role !== 'system' || messages[1]?.role !== 'user' ||
      messages.some((message) => typeof message.content !== 'string' ||
        !message.content.trim() || message.content.length > 7000) ||
      messages.map((message) => message.content).join('').length > 10000) {
    throw error('invalidInput', 'Use a shorter message and conversation history.');
  }
  if (schema?.type !== 'object' || schema.additionalProperties !== false ||
      Object.keys(schema.properties ?? {}).length !== 4 ||
      !Array.isArray(schema.required) || schema.required.length !== 4 ||
      fields.some((field) => schema.properties[field]?.type !== 'string' || !schema.required.includes(field))) {
    throw error('invalidInput', 'The conversation response schema is invalid.');
  }
}

export const responseFieldLimits = { reply: 240, followUpQuestion: 160, suggestedReply: 160, practiceGoal: 160 };

export function boundedResponseSchema(schema) {
  return { ...schema, properties: Object.fromEntries(Object.entries(responseFieldLimits)
    .map(([field, maxLength]) => [field, { ...schema.properties[field], minLength: 1, maxLength }])) };
}

export function validateResponse(output, finishReason) {
  if (finishReason !== 'stop' || typeof output !== 'string' || output.length > 12000) {
    throw error('invalidResponse', 'The model could not finish a short reply. Retry with a shorter message.');
  }
  const fields = ['reply', 'followUpQuestion', 'suggestedReply', 'practiceGoal'];
  let value;
  try { value = JSON.parse(output); } catch {
    throw error('invalidResponse', 'The model returned an incomplete reply. Please try again.');
  }
  if (!value || Array.isArray(value) || Object.keys(value).length !== 4 ||
      fields.some((field) => typeof value[field] !== 'string' ||
        !value[field].trim() || Array.from(value[field]).length > responseFieldLimits[field]) ||
      fields.map((field) => value[field].trim()).join(' ').split(/\s+/).length > 200) {
    throw error('invalidResponse', 'The model returned an incomplete or overly long reply. Please try again.');
  }
  return JSON.stringify(Object.fromEntries(fields.map((field) => [field, value[field].trim()])));
}
