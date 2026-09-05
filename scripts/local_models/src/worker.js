import { MLCEngine } from '@mlc-ai/web-llm';
import { findModel } from './catalog.js';
import { boundedResponseSchema, downloadModelArtifacts, error, isModelCached,
  validateGeneration, validateResponse } from './cache.js';
import { installCacheOnlyNetworkGuard } from './network_guard.js';
import { collectCompletion } from './completion.js';
import { browserConversationMessages } from './conversation_prompt.js';

// Only the explicit download operation can use the original fetch. During
// inference the engine cannot fall back to a network request, even if browser
// eviction occurs after our completeness check. Cache.add performs an internal
// fetch, so guarding global fetch alone would not enforce this requirement.
const downloadFetch = installCacheOnlyNetworkGuard(globalThis);

let engine = null;
let loadedModelId = null;
let active = null;
let generation = 0;
let generationTask = null;
let lastProgressAt = 0;
let lastProgressMessage = '';
let lastProgressId = '';

function progress(id, value) {
  const now = performance.now();
  if (id === lastProgressId && value.message === lastProgressMessage &&
      value.fraction !== 1 && now - lastProgressAt < 120) return;
  lastProgressAt = now;
  lastProgressMessage = value.message;
  lastProgressId = id;
  self.postMessage({ id, type: 'progress', progress: value });
}

function requireIdle() {
  if (active) throw error('busy', 'Please finish or cancel the current local model operation.');
}

async function unloadEngine() {
  generation++;
  engine?.interruptGenerate();
  if (generationTask) await generationTask.catch(() => {});
  if (engine) await engine.unload();
  engine = null;
  loadedModelId = null;
}

async function execute(id, op, args) {
  if (op === 'reset') {
    if (active && active !== 'respond') throw error('busy', 'Please wait for the model operation to finish.');
    generation++;
    if (generationTask) engine?.interruptGenerate();
    if (generationTask) await generationTask.catch(() => {});
    if (engine) await engine.resetChat();
    return null;
  }
  if (op === 'unload') {
    await unloadEngine();
    return null;
  }
  requireIdle();
  active = op;
  try {
    if (op === 'download') {
      const model = findModel(args.modelId);
      await unloadEngine();
      await downloadModelArtifacts(model, {
        fetchFile: downloadFetch,
        onProgress: (value) => progress(id, value),
      });
      // No engine is constructed and no GPU allocation occurs for download.
      return null;
    }
    if (op === 'load') {
      const model = findModel(args.modelId);
      if (!await isModelCached(model)) {
        throw error('missingCache', 'This model is not completely downloaded. Download it before loading.');
      }
      const adapter = await navigator.gpu?.requestAdapter();
      if (!adapter?.features.has('shader-f16')) {
        throw error('unsupported', 'This model requires WebGPU shader-f16 support.');
      }
      await unloadEngine();
      engine = new MLCEngine({
        logLevel: 'WARN',
        appConfig: {
          cacheBackend: 'cache',
          model_list: [{
            model_id: model.id,
            model: model.model,
            model_lib: model.model_lib,
            required_features: model.required_features,
            overrides: { context_window_size: model.context_window_size, prefill_chunk_size: 1024 },
          }],
        },
        initProgressCallback: (value) => progress(id, {
          message: value.text,
          fraction: Number.isFinite(value.progress) ? value.progress : null,
        }),
      });
      try {
        await engine.reload(model.id);
        loadedModelId = model.id;
      } catch (cause) {
        await unloadEngine().catch(() => {});
        throw cause;
      }
      return null;
    }
    if (op === 'respond') {
      if (!engine || !loadedModelId) throw error('notLoaded', 'Load a downloaded model before starting a conversation.');
      validateGeneration(args.messages, args.schema);
      const requestGeneration = ++generation;
      generationTask = (async () => {
        await engine.resetChat();
        if (requestGeneration !== generation) throw error('cancelled', 'Conversation request canceled.');
        const completion = await collectCompletion(engine, {
          model: loadedModelId,
          messages: browserConversationMessages(args.messages,
            loadedModelId.startsWith('gemma-') ? { historyEntries: 6, historyCharacters: 500 } : {}),
          response_format: { type: 'json_object', schema: JSON.stringify(boundedResponseSchema(args.schema)) },
          temperature: 0.3,
          repetition_penalty: 1.15,
          top_p: 0.9,
          max_tokens: 384,
        }, () => requestGeneration === generation);
        if (requestGeneration !== generation) throw error('cancelled', 'Conversation request canceled.');
        return validateResponse(completion.output, completion.finishReason);
      })();
      try { return await generationTask; } finally { generationTask = null; }
    }
    throw error('invalidOperation', 'This model operation is unavailable.');
  } finally {
    active = null;
  }
}

function publicError(cause) {
  if (typeof cause?.code === 'string') return { code: cause.code, message: cause.message };
  if (cause?.name === 'QuotaExceededError') return {
    code: 'storageFull', message: 'There is not enough browser storage. Free some space and retry the download.',
  };
  if (/context|token.*length|length.*token/i.test(cause?.message ?? '')) return {
    code: 'contextTooLong', message: 'This conversation is too long for the model. Reset it or use a shorter message.',
  };
  return { code: 'runtimeError', message: 'The local model could not complete this operation. Check storage, connection, and GPU support, then retry.' };
}

self.onmessage = async ({ data }) => {
  if (typeof data?.id !== 'string' || typeof data.op !== 'string') return;
  try {
    const value = await execute(data.id, data.op, data.args ?? {});
    self.postMessage({ id: data.id, ok: true, value });
  } catch (cause) {
    self.postMessage({ id: data.id, ok: false, error: publicError(cause) });
  }
};
