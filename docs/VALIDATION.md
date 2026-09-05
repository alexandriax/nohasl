# Validation report

Local validation on September 5, 2026, using Flutter 3.35.1, Dart 3.9.0 and Xcode 26.6 (17F113).

| Check | Result | Coverage |
| --- | --- | --- |
| Flutter static analysis | Passed | Application, test and integration code |
| Unit / widget suite | **57 passed** | Existing store/camera/lesson coverage plus 576-activity integrity, legacy-content fingerprints, prerequisite graph, review intervals, schema migration, corrupt-entry salvage, concurrent evidence saves, guided/native conversation handling, availability provenance, reflection privacy, practice/check/recall flows |
| Responsive layout checks | Passed | Original destinations at 1440×1000, 1024×768, 390×844 and 320×740; conversation, practice lab and review hub at desktop, 390px and 320px widths |
| macOS debug build | Passed | Native Apple Silicon app, camera plugin linked |
| macOS integration test | Passed | Real native process: first lesson, completion/XP, library search/bookmark, studio, guided conversation, reflection saving and review queue |
| iOS Simulator debug build | Passed | Native iOS app, camera plugin linked |
| iPhone 17 / iOS 26.5 integration test | Passed | Expanded lesson/XP, library bookmark, free camera mirror, guided conversation, saved reflection and Review & portfolio flow; no framework exceptions |
| iOS standard app launch | Passed | Installed and opened in simulator; screenshot visually inspected |
| Native Apple Intelligence bridge | Passed on macOS and iOS Simulator | Actual channel registration, model availability, real four-field café generation and cancellation/reset; both local platforms reported the model available |
| macOS conversation visual check | Passed | Standard app launched, Apple Intelligence availability displayed and a real café reply rendered with coaching and AI provenance |
| Web release build | Passed | JavaScript build; Flutter's Wasm compatibility dry run also passed |
| Browser smoke test | Passed | Existing completion persisted after reload; program explorer shows 72 units/576 activities; stage-six search filters differentiated material; advanced information-gap lesson opens with reference requirement and partner-specific camera prompt; guided conversation accepts a typed clarification and returns a repair cue |

The native tests caught and drove fixes for shared scroll controllers; responsive tests caught and drove fixes for the short sidebar and narrow camera panel. Browser visual review drove fixes for the hero illustration's bounds and explicit variable-font weights.

Camera tests use mocked platform APIs, and native builds link the actual camera providers. No claim is made that physical camera permissions, frame orientation, device switching, interruptions, thermal behavior or latency have been validated on hardware. The simulator does not supply a real camera. This build requests no microphone, stores no camera frames, and has no sign-recognition model.

An earlier foundation browser run encountered an engine error from a synthesized accessibility-node click. The expanded release accepted semantic clicks in the advanced lesson flow, and pointer navigation was also verified. This is not a substitute for testing with real VoiceOver, NVDA and TalkBack, which remains a release gate.

Windows and Android project targets and CI builds are included; neither platform was locally built or device-tested in this macOS session. The foundation PR has passing remote web, Apple, Windows and Android jobs at commit `8ebb393`. An external Maven Central HTTP 403 in the Android job cleared on retry without source changes. Expanded-branch results are tracked separately in its PR. Native debug apps are development artifacts, not signed distribution releases.

## Visual inspection

- [macOS app](screenshots/macos.png)
- [Web app](screenshots/web.png)
- [iPhone 17 Simulator](screenshots/ios.png)
- [Native on-device conversation](screenshots/macos-conversation.png)

## Reproduce

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/app_test.dart -d macos
flutter test integration_test/app_test.dart -d <ios-simulator-id>
flutter test integration_test/apple_intelligence_native_test.dart -d macos
flutter test integration_test/apple_intelligence_native_test.dart -d <ios-simulator-id>
flutter build web --release --pwa-strategy=none
flutter build macos --debug
flutter build ios --simulator --debug
```

Rebuild the regular app after an integration run: integration tests replace the app's entrypoint with the test harness. The checked-in CI follows this rule before archiving artifacts.
