import { error } from './cache.js';

/** Request ownership lives outside the Worker: terminating a Worker alone does
 * not settle its outstanding promises. Epochs also discard late callbacks. */
export class WorkerClient {
  constructor(createWorker) {
    this.createWorker = createWorker;
    this.epoch = 0;
    this.sequence = 0;
    this.pending = new Map();
    this.worker = null;
    this.starting = null;
    this.startController = null;
  }

  async ensureWorker(allowRuntimeDownload) {
    if (this.worker) return this.worker;
    if (this.starting) return this.starting;
    const epoch = this.epoch;
    const controller = new AbortController();
    this.startController = controller;
    const provisioning = (async () => {
      const worker = await this.createWorker(allowRuntimeDownload, controller.signal);
      if (epoch !== this.epoch) {
        worker.terminate();
        throw error('cancelled', 'The local model operation was canceled.');
      }
      this.worker = worker;
      worker.onmessage = ({ data }) => {
        if (epoch !== this.epoch) return;
        const task = this.pending.get(data?.id);
        if (!task) return;
        if (data.type === 'progress') {
          task.onProgress?.(data.progress);
          return;
        }
        this.pending.delete(data.id);
        clearTimeout(task.timer);
        if (data.ok) task.resolve(data.value);
        else task.reject(error(data.error?.code ?? 'runtimeError',
          data.error?.message ?? 'The local model could not finish this operation.'));
      };
      worker.onerror = () => this.terminate('runtimeLost',
        'The browser stopped the local model worker. Load the model again to retry.');
      worker.onmessageerror = () => this.terminate('runtimeLost',
        'The local model worker could not return its result. Please load it again.');
      return worker;
    })();
    let cancelStart;
    const cancelled = new Promise((_, reject) => {
      cancelStart = () => reject(error('cancelled', 'The local model operation was canceled.'));
      controller.signal.addEventListener('abort', cancelStart, { once: true });
    });
    const starting = Promise.race([provisioning, cancelled]);
    this.starting = starting;
    try { return await starting; } finally {
      controller.signal.removeEventListener('abort', cancelStart);
      if (this.starting === starting) {
        this.starting = null;
        this.startController = null;
      }
    }
  }

  async request(op, args = {}, { onProgress, allowRuntimeDownload = false, timeoutMs = 120000 } = {}) {
    const epoch = this.epoch;
    const worker = await this.ensureWorker(allowRuntimeDownload);
    if (epoch !== this.epoch) throw error('cancelled', 'The local model operation was canceled.');
    const id = `${epoch}:${++this.sequence}`;
    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => this.terminate('timeout',
        'The local model took too long. Load it again, or use guided rehearsal.'), timeoutMs);
      this.pending.set(id, { op, resolve, reject, onProgress, timer });
      try { worker.postMessage({ id, op, args }); } catch {
        this.terminate('runtimeLost', 'The local model worker is unavailable. Please load it again.');
      }
    });
  }

  cancelResponses() {
    for (const [id, task] of this.pending) {
      if (task.op !== 'respond') continue;
      clearTimeout(task.timer);
      task.reject(error('cancelled', 'Conversation request canceled.'));
      this.pending.delete(id);
    }
  }

  terminate(code = 'cancelled', message = 'The local model operation was canceled.') {
    this.epoch++;
    this.startController?.abort();
    this.startController = null;
    this.starting = null;
    this.worker?.terminate();
    this.worker = null;
    for (const task of this.pending.values()) {
      clearTimeout(task.timer);
      task.reject(error(code, message));
    }
    this.pending.clear();
  }
}
