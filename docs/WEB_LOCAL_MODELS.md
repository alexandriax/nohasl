# Optional browser text models

The Flutter web adapter runs an optional text model in a dedicated Web Worker.
Learners choose a model, review its size and license, download it, then load it.
Creating the adapter and checking support do not download model data. The model
receives the bounded English conversation scaffold from
`local_model_prompt.dart`; it receives no camera frames, audio, or sign scores.
Its output is a role-play aid, not ASL instruction or an assessment of signing.

## Reproducible build

```sh
npm --prefix scripts/local_models ci --ignore-scripts
npm --prefix scripts/local_models test
npm --prefix scripts/local_models run build
flutter build web --release
```

`scripts/local_models/package-lock.json` pins the dependency tree. WebLLM is
exactly `@mlc-ai/web-llm@0.2.84`; esbuild is exactly `0.25.9`. The generated
`web/local_models/bridge.js`, content-hashed worker, runtime manifest, and license
files are included in the repository so a normal Flutter build includes them.
Rebuild these outputs after changing their source. A second identical build must
produce the same worker SHA-256 and bridge bytes. The build fails if esbuild
reports any worker module imports. There are no CDN module imports or npm loads
at runtime.

The bridge resolves the worker relative to its own script URL, which supports
Flutter deployments under a non-root base href. The first explicit download also
caches the approximately 6 MB shared application worker. The worker is verified
against the build's SHA-256 and then started from a cached Blob. Subsequent
cache-only model loads do not fetch a worker script URL. After an app update
changes the worker hash, the saved model remains listed as downloaded. Choosing
**Use model** can install just the updated same-origin application worker; it
does not download the model again. If that runtime is unavailable offline, an
actionable message asks the learner to connect once and choose Use again.

## Pinned model catalog

Catalog metadata was checked against public Hugging Face and GitHub APIs on
2026-09-05. Exact artifact URLs, sizes, and upstream hashes are in
`scripts/local_models/src/catalog.js`. The byte total includes the files actually
loaded by WebLLM: every weight shard, `tensor-cache.json`, `mlc-chat-config.json`,
`tokenizer.json`, and the matching compiled WASM library. It excludes unused
alternate tokenizer files and the separate application worker bundle.

| Browser choice | Exact WebLLM ID | Model download | Upstream VRAM estimate | License |
| --- | --- | ---: | ---: | --- |
| Small default | `SmolLM2-360M-Instruct-q4f16_1-MLC` | 211,553,449 bytes | 376.06 MB | Apache 2.0 |
| Larger optional model | `gemma-2-2b-it-q4f16_1-MLC` | 1,493,768,395 bytes | 1,895.3 MB | Gemma Terms of Use |

Both use a 4,096-token context and a 1,024-token prefill chunk. The 4,096 context
preserves room for the shared prompt, bounded history, schema, and reply.
Both require `shader-f16`. These are upstream GPU memory planning estimates, not
measurements of free VRAM or peak browser memory. The UI rounds them upward to
0.4 GiB and 1.9 GiB. Hashing and copying a downloaded file also uses CPU memory;
Gemma's largest shard is approximately 295 MB, so its peak download memory is
higher than a progress bar alone suggests.

SmolLM2 model base:
`https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/`

Gemma model base:
`https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/`

Both WASM URLs use the immutable binary repository commit
`025bcaf3780fa8254f5e5efd3bfea0a5397248f4`, under
`web-llm-models/v0_2_84/base/`, with respective filenames
`SmolLM2-360M-Instruct-q4f16_1_cs1k-webgpu.wasm` and
`gemma-2-2b-it-q4f16_1_cs1k-webgpu.wasm`.

The converted model repositories were public and ungated when checked. Gemma's
public availability does not change its terms. The UI provides a specific terms
notice and link; downloading is an explicit learner action. This build does not
bundle or mirror either model's weights. Distribution notices and software
license text are included in `web/local_models/`.

## Lifecycle and storage

- **Probe:** secure context, Worker, Cache API, Web Crypto, WebGPU adapter, and
  `shader-f16` checks; storage quota estimate when available. No model request.
- **Download:** a worker fetches only artifacts from the fixed catalog, one at a
  time, with omitted credentials. Actual response bytes drive progress. Exact
  length and upstream SHA-256 or Git blob SHA-1 are verified before an atomic
  cache write. Download does not create an inference engine or allocate its GPU
  weights. The worker is terminated on completion to release download buffers.
- **Cancel:** the bridge terminates the worker and rejects pending requests.
  Epochs discard stale completion and progress callbacks, including callbacks
  from a worker that finished creating after cancellation. Cancellation and
  download failure remove that attempt's partial model files after terminating
  its worker; there is no inaccessible partial download left behind. Shared app
  runtime files and other models remain. A model that was complete before a
  failed runtime refresh is preserved. Within an uninterrupted download, already
  verified files can be reused; cancellation deliberately rolls the attempt back.
- **Downloaded status:** every catalog artifact must be present with the verified
  digest marker and exact length. Model inventory is independent of the app's
  worker version so app upgrades do not hide valid model files. WebLLM's
  `hasModelInCache` alone is insufficient because it checks
  weights, not the complete config/tokenizer/WASM set.
- **Load:** only a complete cached model may load. The explicit Use action may
  install an updated same-origin app worker if its version is not cached. The
  model's weight/config/tokenizer/WASM files remain cache-only. The worker's default `fetch`
  and `Cache.add`/`addAll` paths reject requests. Only the private fetch function
  used by explicit download can reach the network. If a file is evicted between
  the completeness check and engine loading, load fails instead of fetching it.
- **Respond:** the browser adapts the shared Dart context into compact system
  instructions, at most one recent completed exchange for SmolLM2 or three for
  Gemma as alternating chat roles, and the learner's
  latest meaning as the final plain user turn. It preserves the text-only,
  no-assessment guardrails and avoids a copyable example in the small model's
  context. The native adapter's input is unchanged. The shared four-field schema
  is passed to WebLLM `response_format: {type: 'json_object', schema: JSON.stringify(schema)}`.
  Each field is nonempty and bounded by the grammar: 240 characters for `reply`,
  160 for each remaining field. Repetition penalty 1.15 reduces looping in the
  small model. Generation is limited to 384 tokens and
  buffered internally through the public streaming API. Both JS and Dart parse the result. JS
  rejects truncated generation, extra or missing fields, wrong types, empty
  fields, and excessive length. Valid JSON does not establish factual accuracy.
- **Reset:** interrupt generation, invalidate pending output, and reset the chat
  cache while keeping loaded model weights. Each generated turn also resets the
  engine chat state because the bounded conversation is explicitly supplied.
  An interrupted stream is drained before its result is discarded so WebLLM
  0.2.84 releases its generation lock. Idle reset does not set an interrupt flag;
  the streaming entry point clears a prior flag when the next generation starts.
- **Unload/dispose:** terminate the worker, cancel outstanding work, and release
  inference state. Downloaded artifacts remain.
- **Remove:** delete the exact selected model's keys in `webllm/model`,
  `webllm/config`, and `webllm/wasm`. Do not delete entire cache namespaces,
  learning progress, runtime scripts, or unrelated models. The deletion helper
  preserves any future shared artifact referenced by another offered model.

The bridge exposes one JSON RPC entry point, `nohaslLocalModels.invoke(request,
progressCallback)`. Operations are `probe`, `catalog`, `downloadedModels`,
`download`, `cancelDownload`, `load`, `respond`, `reset`, `unload`, `remove`, and
`dispose`. Success and failure are JSON envelopes; errors are not unhandled JS
exceptions crossing the Dart boundary. Only one engine operation runs at a time.

Cached models can be loaded and used without network access while the app is
open. A cold offline app launch additionally requires the hosting/PWA setup to
cache Flutter's own shell, CanvasKit, fonts, and app assets. Browser quota and
eviction policies can remove cached data. Storage is scoped to the exact browser
profile and origin; changing hostname or port creates a different storage scope.
This implementation does not promise permanent storage or universal WebGPU
support. If deployment uses CSP, it must allow same-origin scripts, `worker-src
'self' blob:`, and the chosen model hosts/redirect destinations for the explicit
download. Inference does not require an external network endpoint.

## Verification

The experimental SmolLM2 browser path has been exercised through the Flutter
app UI: explicit download, cancellation, a complete download, cached model load,
and generation of a complete four-field conversation turn. The initial small
model run repeated text inside its first field; the verified field-length
constraints and repetition control resolved that observed failure. A valid
structured reply is not a measure of ASL knowledge or educational quality. Gemma
artifact metadata and license links are verified, but Gemma browser inference
has **not** been tested. The larger model must not be advertised as validated by
the SmolLM2 result.

SmolLM2's conversational quality remains limited. In a subsequent gardening
exchange it stayed on topic and supplied a relevant suggested reply, but echoed
the learner's question instead of answering it; its practice goal also echoed a
formatting instruction. It can repeat meanings, copy instructions, or produce
awkward role-play even when all four fields are valid. This verifies a working
experimental local runtime, not natural conversation or dependable coaching.
Learners should be able to choose another available provider or guided
rehearsal. The optional larger Gemma model requires its own inference and quality
evaluation; its larger size alone is not evidence of success.

The Node suite covers pinned artifact totals and versions, completion accounting,
missing config despite cached weights, cancellation and partial-file cleanup, bad hashes
and truncated responses, scoped offline deletion, support probes, network guards,
strict output parsing, worker failure, stale results, and cancellation before a
worker finishes starting. App-update tests verify that only the new app worker
is fetched, saved model files remain untouched, and subsequent loads require no
script request. Dart web adapter analysis is also run independently.
These tests use simulated workers/storage and do not measure language quality.
The exact bundled XGrammar and pinned Smol tokenizer were also checked on CPU:
the schema accepts a 240-character reply, rejects 241 characters, rejects a
161-character follow-up, and rejects empty fields, using both text and token
sequence validation. This checks the actual grammar compiler rather than only a
JavaScript length check.

The browser release smoke test must use the app's explicit small-model download,
load, and conversation UI on a real WebGPU-capable browser. Verify a four-field
response, at least two distinct conversation turns, reset during generation,
unload, reload from cache with the network disabled, and deletion. Inspect
network requests to verify that cached model load/generation fetch neither
scripts nor model files. Check download cancellation/retry, missing-artifact
recovery, a deployment with a non-root base href, and the no-WebGPU state. Gemma
is a separate larger-model smoke test; passing SmolLM2 does not validate Gemma's
memory allocation or response quality.

## Primary sources

- [WebLLM package metadata](https://www.npmjs.com/package/@mlc-ai/web-llm) and
  [upstream repository](https://github.com/mlc-ai/web-llm): the published 0.2.84
  tarball was inspected directly, including cache and cancellation behavior.
- [WebLLM worker and cache documentation](https://webllm.mlc.ai/docs/user/advanced_usage.html)
  and [API reference](https://webllm.mlc.ai/docs/user/api_reference.html).
- [XGrammar 0.1.27 JSON-schema implementation](https://github.com/mlc-ai/xgrammar/blob/v0.1.27/cpp/json_schema_converter.cc)
  supports the `minLength` and `maxLength` constraints used here.
- [SmolLM2 original model card and license](https://huggingface.co/HuggingFaceTB/SmolLM2-360M-Instruct)
  and [MLC conversion](https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC).
- [Gemma MLC conversion](https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC),
  [Gemma Terms of Use](https://ai.google.dev/gemma/terms), and
  [Gemma prohibited-use policy](https://ai.google.dev/gemma/prohibited_use_policy).
- [Compiled MLC libraries at the pinned commit](https://github.com/mlc-ai/binary-mlc-llm-libs/tree/025bcaf3780fa8254f5e5efd3bfea0a5397248f4/web-llm-models/v0_2_84/base).
- [WebGPU adapter requirements](https://developer.mozilla.org/en-US/docs/Web/API/GPU/requestAdapter)
  and [browser storage estimates](https://developer.mozilla.org/en-US/docs/Web/API/StorageManager/estimate).
