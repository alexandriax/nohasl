import test from 'node:test';
import assert from 'node:assert/strict';
import { WorkerClient } from '../src/worker_client.js';

class FakeWorker {
  messages = [];
  terminated = false;
  postMessage(message) { this.messages.push(message); }
  terminate() { this.terminated = true; }
  answer(index, value) { this.onmessage({ data: { id: this.messages[index].id, ok: true, value } }); }
  progress(index, progress) { this.onmessage({ data: { id: this.messages[index].id, type: 'progress', progress } }); }
}
const turn = () => new Promise((resolve) => setImmediate(resolve));

test('terminating a worker settles its download and ignores a late success or progress event', async () => {
  const worker = new FakeWorker();
  const client = new WorkerClient(async () => worker);
  const updates = [];
  const request = client.request('download', {}, { onProgress: (progress) => updates.push(progress) });
  await turn();
  const rejected = assert.rejects(request, { code: 'cancelled' });
  client.terminate();
  await rejected;
  worker.progress(0, { fraction: 1 });
  worker.answer(0, 'stale');
  assert.deepEqual(updates, []);
  assert.equal(worker.terminated, true);
  assert.equal(client.pending.size, 0);
});

test('cancel settles even while worker creation is pending and terminates the eventual worker', async () => {
  let finishCreating;
  const worker = new FakeWorker();
  const client = new WorkerClient(() => new Promise((resolve) => { finishCreating = resolve; }));
  const request = client.request('download');
  await turn();
  const rejected = assert.rejects(request, { code: 'cancelled' });
  client.terminate();
  await rejected;
  finishCreating(worker);
  await turn();
  assert.equal(worker.terminated, true);
  assert.equal(worker.messages.length, 0);
});

test('reset cancels response output while keeping loaded worker available for reset RPC', async () => {
  const worker = new FakeWorker();
  const client = new WorkerClient(async () => worker);
  const response = client.request('respond');
  await turn();
  const rejected = assert.rejects(response, { code: 'cancelled' });
  client.cancelResponses();
  await rejected;
  const reset = client.request('reset');
  await turn();
  worker.answer(0, 'stale reply');
  worker.answer(1, null);
  assert.equal(await reset, null);
  assert.equal(worker.terminated, false);
  client.terminate();
});

test('worker failure rejects pending work and the next request creates a fresh worker', async () => {
  const first = new FakeWorker();
  const next = new FakeWorker();
  let count = 0;
  const client = new WorkerClient(async () => count++ === 0 ? first : next);
  const request = client.request('load');
  await turn();
  const rejected = assert.rejects(request, { code: 'runtimeLost' });
  first.onerror();
  await rejected;
  const retry = client.request('load');
  await turn();
  next.answer(0, null);
  assert.equal(await retry, null);
  assert.equal(count, 2);
  client.terminate();
});
