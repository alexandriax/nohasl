# Downloadable native conversation models

Apple Intelligence remains the preferred available on-device provider. This
optional provider runs a bundled llama.cpp library inside the app process. It
does not use an external service, Ollama installation, local server, or cloud
inference fallback. The learner explicitly downloads and loads a model.

The model supplies short **English meaning scaffolds** for conversation
rehearsal. It cannot observe the camera, translate ASL, teach authoritative sign
formation, assess signing, or certify fluency. Small-model output can be mistaken
or unhelpful. The app validates all four response fields before displaying a turn.

## Runtime and build decisions

The native adapter uses `llamadart: 0.8.22`, whose package archive pins
`leehack/llamadart-native@v0.3.0`. The project uses Flutter 3.38.10 / Dart 3.10.9.
This is a narrow upgrade from Flutter 3.35.1: the runtime requires Dart 3.10.7 or
newer. The official Flutter release manifest confirms the selected pairing.

Native build hooks fetch architecture-specific libraries at **build time** and
bundle them with the application. Models are separate runtime downloads. The
app explicitly selects only `llama_cpp` native assets, excluding the LiteRT-LM
runtime and its accelerator dependencies. Non-Apple targets select only the CPU
backend. macOS uses the small consolidated CPU/Metal runtime and requests Metal.
iOS initially uses CPU for consistent simulator/device behavior.

| Target | Runtime architecture coverage | App configuration |
| --- | --- | --- |
| macOS | arm64, x86_64 | macOS 14 minimum; Metal |
| iOS | arm64 device, arm64/x86_64 simulator | iOS 16.4 minimum; CPU initially |
| Windows | x64, arm64 | CPU bundle selection |
| Android | arm64, x64 only | CPU bundle selection; API 24 minimum; 64-bit device required |
| Linux | x64, arm64 | CPU bundle selection |

Coverage above is the runtime publisher's matrix, not a claim of physical-device
testing on every target. See the verification record below for actual checks.
The core package's native-assets path is used without SwiftPM companion plugins.
No Xcode project migration or additional model runtime server is required.

The pinned macOS arm64 runtime archive is about 4.35 MB; iOS archives are about
4.2 MB. The Windows x64 **build download** is around 732 MB because the publisher
ships one archive containing several accelerators. Hook configuration trims the
app's copied libraries to CPU; the application does not bundle CUDA. CI needs
network access on the first build and should cache native build inputs. Avoid
overriding the native version independently of the Dart bindings: their ABI must
match. Native code is part of the installed application, never downloaded by
the running app.

Android Gradle ABI filters restrict APK contents to `arm64-v8a` and `x86_64`.
Build with `flutter build apk --target-platform android-arm64,android-x64` so
Flutter's native-assets hook also skips unsupported 32-bit targets. ARMv7 devices
are not supported by this app build.

Sources: [llamadart package](https://pub.dev/packages/llamadart),
[runtime platform matrix](https://llamadart.leehack.com/docs/platforms/support-matrix),
[native release](https://github.com/leehack/llamadart-native/releases/tag/v0.3.0),
[Flutter release manifest](https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json).

## Pinned starter model

The initial native catalog contains the official Qwen 2.5 0.5B Instruct GGUF.
It is ungated and its repository declares Apache 2.0. No Hugging Face account or
token is required. This is a compact starter option with modest conversational
quality, not a fluency assessor. Estimated memory of 1.2 GiB is a planning hint,
not a measurement of free memory or a guarantee for every device.

| Field | Pin |
| --- | --- |
| Repository | `Qwen/Qwen2.5-0.5B-Instruct-GGUF` |
| Revision | `9217f5db79a29953eb74d5343926648285ec7e67` |
| File | `qwen2.5-0.5b-instruct-q4_k_m.gguf` |
| Bytes | `491400032` |
| SHA-256 | `74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db` |

The download URL uses the revision, never a moving `main` branch. Catalog source
and license links are visible in the application. Other model families require
their own license and gating review before catalog inclusion; Gemma is not
silently downloaded or bundled. [Qwen model and license](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/tree/9217f5db79a29953eb74d5343926648285ec7e67).

## Storage and lifecycle

Only an explicit download action opens an HTTPS model request. Network access
is used for model bytes; conversation text and camera frames are never sent.
macOS has the sandbox network-client entitlement and Android has INTERNET
permission for this download. No microphone, upload, or local-network discovery
permission is added.

The adapter writes to the app cache directory's `nohasl_local_models` child.
Apple's caches policy excludes this redownloadable data from iCloud backups and
allows the OS to reclaim it. If reclaimed, the app reports the model missing;
loading does not silently fetch it again. See [Apple file-system guidance](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html).

Download writes an owned `.part` file, enforces the exact byte limit, checks
SHA-256, then renames the result atomically. Cancellation closes the HTTP client,
waits for the operation to settle, removes the partial, and prevents a late
rename from publishing a cancelled model. Interrupted downloads currently restart
from zero. Complete cached artifacts are checked by byte length and SHA-256,
including before loading. Model removal deletes only the two allowlisted
filenames; unrelated cache files remain untouched.

All engine load/generate/reset/unload operations share one serialized queue.
Generation has a bounded 4,096-token context, at most 320 output tokens, a
60-second cancellation deadline, and a native cancellation flag. Every completion
checks a generation epoch, so cancelled/reset replies cannot become visible.
The adapter waits for native decode settlement before freeing its context.
The JSON grammar constrains the four-field shape, and application validation
rejects empty, oversized, or malformed content. Prefix reuse and runtime logs
are disabled. No model conversation or native KV state is written to disk.

The current package has no public clear-context method. Reset therefore cancels,
waits, unloads, then reloads the already cached model to release the previous
native context. It restores the logical loaded state at the cost of a short
reload. Unload releases inference memory; neither operation deletes weights.

## Alternatives checked

* `flutter_gemma 1.7.1` + `flutter_gemma_litertlm 1.6.2` require Flutter 3.44 and
  Dart 3.12. Desktop uses `.litertlm`, with macOS arm64 and Windows x64 support.
  The older 0.16.5 monolith fails the actual Dart 3.9 solver because its tokenizer
  dependency requires Dart 3.10.7. Its larger runtime stack is unnecessary here.
* `llama_cpp_flutter 0.8.0` advertises Dart 3.9 but fails Flutter 3.35.1's pinned
  `characters` dependency, and does not implement Windows or Android.
* `llama_cpp_dart 0.2.2` resolves on older Dart but requires more native packaging
  ownership; its 0.9 rewrite targets Apple/mobile rather than our full desktop
  matrix.
* `llm_llamacpp 0.3.0` resolves on Dart 3.9, but the inspected token loop logs
  generated text and lacks cooperative cancellation polling. Its public README
  also lags its native build-hook implementation.

These checks used actual pub.dev package metadata, extracted package source,
and temporary dependency-resolution projects. No global Flutter installation
was changed. [Gemma packages](https://pub.dev/packages/flutter_gemma),
[llama_cpp_flutter](https://pub.dev/packages/llama_cpp_flutter),
[llama_cpp_dart](https://pub.dev/packages/llama_cpp_dart),
[llm_llamacpp](https://pub.dev/packages/llm_llamacpp).

## Verification

The normal test suite checks corrupt/partial cache handling and deletion scope.
An opt-in native smoke suite performs a real public HTTP download cancellation
and real Qwen generation, reset, cancellation, unload, and deletion:

```sh
flutter test test/native_local_model_runtime_test.dart \
  --dart-define=NOHASL_NATIVE_MODEL_PATH=/absolute/path/to/qwen2.5-0.5b-instruct-q4_k_m.gguf \
  --reporter expanded
```

The fixture must be the exact model above. It is copied into a temporary test
cache, checked against the production hash, and removed after the test. Synthetic
conversation output may be printed by this opt-in test; application runtime
logging is disabled. A full 491,400,032-byte model download was independently
completed and SHA-256 verified during implementation. Runtime test results are
recorded below.

Verified on 2026-09-05: all three opt-in VM/native smoke tests passed in 51
seconds on the Apple Silicon Mac. The real Metal-backed first conversation turn
took 2,862 ms and returned all four validated fields. The same suite verified
HTTP cancellation, native generation cancellation/reset, a subsequent response,
unloading, and scoped removal. Model phrasing showed the expected limitations
of a 0.5B model; the catalog explicitly describes it as experimental.

`integration_test/native_local_models_test.dart` exercises the same adapter
inside the actual platform application, including native asset loading. Pass
an app-readable fixture path to avoid another download. Sandboxed apps usually
cannot read an arbitrary host path. In that case the opt-in test downloads and
verifies the model into a temporary app directory, checks that it remains
unloaded after download, runs inference/cancellation/reset, and removes it.

Packaged-platform verification on 2026-09-05:

| Check | Result |
| --- | --- |
| macOS full learning/application flow | Passed, 11 seconds |
| macOS actual model download + Metal inference + cancellation/reset + removal | Passed, 1 minute 46 seconds |
| iPhone 17 / iOS 26.5 simulator application flow | Passed, 16 seconds |
| iOS actual app-cache download + CPU inference + cancellation/reset + removal | Passed, 1 minute 34 seconds |
| macOS Apple Intelligence native availability + real generation + reset | Passed, 13 seconds; model available |
| iOS Apple Intelligence native availability + real generation + reset | Passed, 4 seconds; model available |
| Scoped native Dart analysis | No issues |

Each packaged model test downloaded all 491,400,032 bytes through the production
adapter, verified the pinned SHA-256, generated all four response fields, and
deleted only its temporary model files. The iOS check also exercised the real
`path_provider` app-cache API. Physical iOS/Android devices and Windows/Linux
runtime inference have not been exercised in this workspace.

The SDK upgrade required removing this project's old macOS build intermediates
and iOS Xcode DerivedData once: their precompiled headers referenced the previous
Flutter framework. Fresh native builds succeeded after clearing those derived
artifacts; no camera or Apple Intelligence bridge source workaround was needed.
