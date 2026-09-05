import { error } from './cache.js';

/** Buffer streaming output internally. WebLLM 0.2.84's non-streaming entry
 * checks a previous interrupt flag before resetting it; the streaming entry
 * resets that flag for each new generation through its public API. */
export async function collectCompletion(engine, request, isCurrent = () => true) {
  const stream = await engine.chat.completions.create({
    ...request, stream: true, stream_options: { include_usage: true },
  });
  let output = '';
  let finishReason;
  let usage;
  let failure;
  for await (const chunk of stream) {
    if (!isCurrent() && !failure) {
      failure = error('cancelled', 'Conversation request canceled.');
      engine.interruptGenerate();
    }
    const choice = chunk.choices?.[0];
    if (!failure && typeof choice?.delta?.content === 'string') output += choice.delta.content;
    if (choice?.finish_reason) finishReason = choice.finish_reason;
    if (chunk.usage) usage = chunk.usage;
    if (!failure && output.length > 12000) {
      engine.interruptGenerate();
      failure = error('invalidResponse', 'The model returned too much text. Please try a shorter message.');
    }
    // Drain to normal completion after interruption. WebLLM 0.2.84 releases
    // its generation lock at the iterator tail, without an outer finally;
    // an early consumer throw/return would skip that release and break reset.
  }
  if (failure) throw failure;
  if (!isCurrent()) throw error('cancelled', 'Conversation request canceled.');
  return { output, finishReason, usage };
}
