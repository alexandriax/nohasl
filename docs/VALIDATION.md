# Validation report

Local validation on September 5, 2026, using Flutter 3.35.1, Dart 3.9.0 and Xcode 26.6 (17F113).

| Check | Result | Coverage |
| --- | --- | --- |
| Flutter static analysis | Passed | Application, test and integration code |
| Unit / widget suite | 19 passed | Store persistence, unique XP, actual elapsed minutes, streak gaps, reset, corrupt-state recovery, curriculum consistency, camera lifecycle/errors/timer/self-review, lesson answer validation/completion, library search/bookmark |
| Responsive layout checks | Passed | All six pages at 1440×1000, 1024×768, 390×844 and 320×740 |
| macOS debug build | Passed | Native Apple Silicon app, camera plugin linked |
| macOS integration test | Passed | Real native process: first lesson, answer validation, completion/XP, library search/bookmark, navigation to studio |
| iOS Simulator debug build | Passed | Native iOS app, camera plugin linked |
| iPhone 17 / iOS 26.5 integration test | Passed | Same learning/navigation flow, no framework exceptions |
| iOS standard app launch | Passed | Installed and opened in simulator; screenshot visually inspected |
| Web release build | Passed | JavaScript build; Flutter's Wasm compatibility dry run also passed |
| Browser smoke test | Passed | Dashboard rendering, pointer navigation, keyboard-operated lesson flow, consent-first practice panel, completion and persistence after reload |

The native tests caught and drove fixes for shared scroll controllers; responsive tests caught and drove fixes for the short sidebar and narrow camera panel. Browser visual review drove fixes for the hero illustration's bounds and explicit variable-font weights.

Camera tests use mocked platform APIs, and native builds link the actual camera providers. No claim is made that physical camera permissions, frame orientation, device switching, interruptions, thermal behavior or latency have been validated on hardware. The simulator does not supply a real camera. This build requests no microphone, stores no camera frames, and has no sign-recognition model.

The web browser's synthesized accessibility-node click produced a Flutter engine event error during automation. Physical pointer navigation and keyboard activation were separately verified. Assistive-technology testing on real VoiceOver, NVDA and TalkBack remains a release gate.

Windows and Android project targets and CI builds are included; neither platform was locally built or device-tested in this macOS session. CI configuration is checked in, but no GitHub Actions run is claimed before it has actually run. Native debug apps are development artifacts, not signed distribution releases.

## Visual inspection

- [macOS app](screenshots/macos.png)
- [Web app](screenshots/web.png)
- [iPhone 17 Simulator](screenshots/ios.png)

## Reproduce

```sh
flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/app_test.dart -d macos
flutter test integration_test/app_test.dart -d <ios-simulator-id>
flutter build web --release --pwa-strategy=none
flutter build macos --debug
flutter build ios --simulator --debug
```

Rebuild the regular app after an integration run: integration tests replace the app's entrypoint with the test harness. The checked-in CI follows this rule before archiving artifacts.
