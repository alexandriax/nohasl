import test from 'node:test';
import assert from 'node:assert/strict';
import { collectCompletion } from '../src/completion.js';

test('public streaming path starts a fresh generation after a prior interrupt and buffers all four fields', async () => {
  const output = '{"reply":"Hi","followUpQuestion":"Coffee?","suggestedReply":"Yes","practiceGoal":"Take a turn"}';
  let interrupted = true;
  const engine = { chat: { completions: {
    async create(request) {
      assert.equal(request.stream, true, 'non-streaming path would observe a stale interrupt');
      assert.deepEqual(request.stream_options, { include_usage: true });
      return (async function* () {
        interrupted = false;
        yield { choices: [{ delta: { role: 'assistant' }, finish_reason: null }] };
        yield { choices: [{ delta: { content: output.slice(0, 20) }, finish_reason: null }] };
        yield { choices: [{ delta: { content: output.slice(20) }, finish_reason: 'stop' }] };
        yield { choices: [], usage: { completion_tokens: 30 } };
      })();
    },
  } } };
  const result = await collectCompletion(engine, { messages: [] });
  assert.equal(interrupted, false);
  assert.equal(result.output, output);
  assert.equal(result.finishReason, 'stop');
  assert.equal(result.usage.completion_tokens, 30);
});

test('reset drains interrupted output to the tail so the runtime releases its lock', async () => {
  let current = true;
  let released = false;
  let interrupts = 0;
  const engine = {
    interruptGenerate: () => { interrupts++; },
    chat: { completions: { create: async () => (async function* () {
      yield { choices: [{ delta: { content: '{"reply":' } }] };
      current = false;
      yield { choices: [{ delta: { content: '"stale"}' }, finish_reason: 'stop' }] };
      released = true; // Deliberately not in finally, matching WebLLM 0.2.84.
    })() } },
  };
  await assert.rejects(collectCompletion(engine, {}, () => current), { code: 'cancelled' });
  assert.equal(interrupts, 1);
  assert.equal(released, true);
});
