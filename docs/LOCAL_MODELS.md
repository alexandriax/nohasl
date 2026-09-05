# Optional local conversation models

The conversation room can use Apple Intelligence, a downloaded local model, or
an authored guided rehearsal. Apple Intelligence is the first choice when it is
available on an eligible Apple device. A saved learner choice takes precedence
on subsequent visits. This preference never authorizes a new download.

## Choose and manage a model

1. Open **Conversation room → Optional local models**. The app checks runtime
   support and actual cached files without fetching model weights.
2. Select **Review download**. Review the download size, estimated memory,
   source, and license. Gemma requires an explicit acknowledgment of its terms.
3. Confirm the download. Progress and cancellation remain available. Downloads
   continue when navigating to another part of the app; closing the app can
   interrupt them. Downloading does not begin inference or change providers.
4. Select **Use model** after installation. This loads cached weights and starts
   a fresh conversation. An explicit previously saved choice may load the same
   cached weights on a later visit, but never downloads missing files.
5. Use **Cancel reply**, **New conversation**, or change providers to reset the
   conversation. **Remove model** releases its inference memory and removes its
   owned weights. Reflections and course progress are unaffected.

| Platform | Optional model | Model download | Planning memory |
| --- | --- | ---: | ---: |
| WebGPU browser with shader-f16 | SmolLM2 360M, experimental | 212 MB | See in-app estimate; device overhead varies |
| WebGPU browser with shader-f16 | Gemma 2 2B | 1.49 GB | See in-app estimate; device overhead varies |
| macOS, iOS, Windows, Android | Qwen 2.5 0.5B, experimental | 491 MB | Approximately 1.2 GiB |

The browser runtime adds approximately 6 MB of bundled JavaScript to the web
application; model weights are separate. Native llama.cpp libraries are bundled
at build time. The native optional provider also works on Apple platforms,
including eligible devices where the learner prefers Apple Intelligence.
Unsupported browsers retain guided rehearsal. There is no cloud fallback,
account requirement, access-token entry, or separate local server to install.

Compact models can be repetitive, confused about roles, or inaccurate. They
provide English conversation ideas and self-review prompts. They cannot observe
signing, translate English into ASL, or determine proficiency. Signed language
practice still uses authentic learning references, the camera mirror, partners,
and qualified feedback. Choosing a larger model does not change that boundary.

## Privacy and reliability

Conversation and camera data are not sent to model hosts. Only explicit setup
fetches model files; generation runs in the browser worker or native app process.
History is bounded in memory and not saved. The app persists the provider choice
separately from learning progress. A learner may deliberately save a reflection,
which follows the existing reflection-only storage policy.

Model URLs use pinned revisions with byte counts and cryptographic hashes.
Partial or corrupt downloads never count as installed. Browser eviction or OS
cache reclamation can remove model files. Cached-only loading fails visibly
instead of silently downloading again. Removal is limited to the selected
model's files; it never clears the browser's unrelated caches or learning state.

Downloads and inference are serialized by an app-scoped manager. Epoch checks
reject late completions after cancellation, reset, removal, or page disposal.
Provider changes clear the conversation so responses cannot be mislabeled as
coming from another model. Malformed model output produces a retryable error;
the interface never presents an authored fallback as generated text.

## Engineering and verification

Use Flutter **3.38.10 / Dart 3.10.9** and Node 22 to rebuild the pinned browser
bundle. The application minimums are now **iOS 16.4 / macOS 14** for native
runtime compatibility. Apple Intelligence retains its own iOS/macOS 26 and
hardware availability checks.

- [Browser adapter](WEB_LOCAL_MODELS.md): manifests, bundled worker, WebGPU,
  cache-only loading, runtime license notices, and JavaScript tests.
- [Native adapter](NATIVE_LOCAL_MODELS.md): pinned runtime and weights, platform
  packaging, bounded structured generation, cache integrity, and real-model tests.
- [Validation report](VALIDATION.md): completed checks and remaining hardware QA.

The backend interface and manager are independent of Flutter views. Adding a
model requires a reviewed license, a pinned artifact manifest, accurate storage
and memory estimates, structured-generation compatibility, and real platform
inference checks. Arbitrary unverified model URLs are deliberately not exposed
as an in-app option.
