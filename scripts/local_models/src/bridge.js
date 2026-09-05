import { models, findModel } from './catalog.js';
import { cachedModelIds, deleteModelArtifacts, error, isModelCached, probeSupport,
  rollbackModelDownload } from './cache.js';
import { WorkerClient } from './worker_client.js';
import { RuntimeCache } from './runtime_cache.js';

// Replaced by build.mjs with a content-hashed filename. The already downloaded
// worker runs from a Blob. After an app update, an explicit Use action can
// install the updated application worker without downloading any model files.
const runtimeUrl = new URL(__NOHASL_WORKER_FILE__, document.currentScript.src).href;
const runtimeHash = __NOHASL_WORKER_HASH__;
const runtimeBytes = __NOHASL_WORKER_BYTES__;
let active = null;
let loadedModelId = null;

const runtime = new RuntimeCache({ url: runtimeUrl, hash: runtimeHash, bytes: runtimeBytes });

const client = new WorkerClient(async (allowDownload, signal) => {
  const source = await runtime.source({ allowInstall: allowDownload, signal });
  const blobUrl = URL.createObjectURL(new Blob([source], { type: 'text/javascript' }));
  const worker = new Worker(blobUrl, { name: 'nohasl-local-text-model' });
  // Workers copy the script URL during construction; the Blob can be revoked
  // on termination. Revoking immediately is less portable across browsers.
  const terminate = worker.terminate.bind(worker);
  worker.terminate = () => { terminate(); URL.revokeObjectURL(blobUrl); };
  return worker;
});

async function exclusive(kind, action) {
  if (active) throw error('busy', 'Finish or cancel the current local model operation first.');
  const token = { kind };
  active = token;
  try { return await action(token); } finally { if (active === token) active = null; }
}

function ensureCurrent(token) {
  if (active !== token) throw error('cancelled', 'The local model operation was canceled.');
}

function rollbackDownload(session) {
  // Cancellation and the rejected download race to this shared promise. Both
  // await the same cleanup, and neither can kill a subsequently started worker.
  session.cleanup ??= rollbackModelDownload(session.model, models, {
    stopWorker: () => client.terminate(),
    wasCompleteBefore: session.wasCompleteBefore,
  });
  return session.cleanup;
}

async function operation(op, args, onProgress) {
  switch (op) {
    case 'catalog': return models.map(({ artifacts, model, model_lib, required_features, context_window_size, ...metadata }) => metadata);
    case 'probe': return probeSupport();
    case 'downloadedModels':
      // An app update changes the worker hash, not the installed model files.
      return cachedModelIds(models);
    case 'download': return exclusive('download', async (token) => {
      const model = findModel(args.modelId);
      const session = { model, wasCompleteBefore: isModelCached(model), cleanup: null };
      token.session = session;
      try {
        const [support] = await Promise.all([probeSupport(), session.wasCompleteBefore]);
        ensureCurrent(token);
        if (!support.available) throw error('unsupported', support.reason);
        loadedModelId = null;
        onProgress?.({ message: 'Preparing the local download…', totalBytes: model.downloadBytes });
        await client.request('download', { modelId: model.id }, {
          allowRuntimeDownload: true, onProgress, timeoutMs: 30 * 60 * 1000,
        });
        ensureCurrent(token);
        client.terminate();
        return null;
      } catch (cause) {
        await rollbackDownload(session);
        throw cause;
      }
    });
    case 'cancelDownload': {
      if (active?.kind === 'cancelDownload') return rollbackDownload(active.session);
      if (active?.kind === 'download') {
        const session = active.session;
        const token = { kind: 'cancelDownload', session };
        active = token;
        loadedModelId = null;
        try { await rollbackDownload(session); } finally {
          if (active === token) active = null;
        }
      }
      return null;
    }
    case 'load': return exclusive('load', async (token) => {
      const model = findModel(args.modelId);
      if (!await isModelCached(model)) {
        throw error('missingCache', 'Download this model completely before loading it.');
      }
      ensureCurrent(token);
      loadedModelId = null;
      await client.request('load', { modelId: model.id }, {
        allowRuntimeDownload: true, onProgress, timeoutMs: 180000,
      });
      ensureCurrent(token);
      loadedModelId = model.id;
      return null;
    });
    case 'respond': return exclusive('respond', async () => {
      if (!loadedModelId || !client.worker) throw error('notLoaded', 'Load a downloaded model before continuing.');
      return client.request('respond', args, { timeoutMs: 90000 });
    });
    case 'reset': {
      if (active && active.kind !== 'respond') throw error('busy', 'Please wait for the current model operation.');
      client.cancelResponses();
      const token = { kind: 'reset' };
      active = token;
      try {
        if (client.worker) await client.request('reset', {}, { timeoutMs: 15000 });
      } finally { if (active === token) active = null; }
      return null;
    }
    case 'unload': {
      const previous = active;
      const token = { kind: 'unload' };
      active = token;
      loadedModelId = null;
      client.cancelResponses();
      try {
        if (previous?.kind === 'download' || previous?.kind === 'cancelDownload') {
          await rollbackDownload(previous.session);
        } else if (client.worker && (!previous || previous.kind === 'respond')) {
          // Give WebLLM the chance to explicitly dispose its GPU resources.
          // Termination also handles a GPU operation that stops yielding to JS.
          await client.request('unload', {}, { timeoutMs: 5000 }).catch(() => {});
        }
      } finally {
        if (active === token) {
          active = null;
          client.terminate();
        }
      }
      return null;
    }
    case 'remove': return exclusive('remove', async () => {
      const model = findModel(args.modelId);
      if (loadedModelId === model.id) {
        client.terminate();
        loadedModelId = null;
      }
      await deleteModelArtifacts(model, models);
      return null;
    });
    case 'dispose': {
      const previous = active;
      if (previous?.kind === 'download' || previous?.kind === 'cancelDownload') {
        await rollbackDownload(previous.session);
      }
      active = null;
      loadedModelId = null;
      client.terminate();
      return null;
    }
    default: throw error('invalidOperation', 'This model operation is unavailable.');
  }
}

// JSON strings keep the Dart interop boundary narrow and independent of the
// JS runtime's object representations. Errors are data, never thrown JS values.
globalThis.nohaslLocalModels = {
  async invoke(requestJson, progressCallback) {
    try {
      const request = JSON.parse(requestJson);
      const value = await operation(request.op, request.args ?? {},
        progressCallback ? (progress) => progressCallback(JSON.stringify(progress)) : null);
      return JSON.stringify({ ok: true, value: value ?? null });
    } catch (cause) {
      return JSON.stringify({ ok: false, error: {
        code: typeof cause?.code === 'string' ? cause.code : (cause?.name === 'AbortError' ? 'cancelled' : 'runtimeError'),
        message: typeof cause?.code === 'string' ? cause.message : 'The local model operation could not finish. Please retry.',
      } });
    }
  },
};
