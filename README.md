# nohasl

A thoughtfully designed Flutter studio for learning American Sign Language through lessons, stories, and hands-on practice. Web, macOS, and iOS are the initial focus; Android and Windows targets are also included.

## What is built

- A responsive learning dashboard, six-level curriculum, practice studio, interactive story scenes, searchable sign library, and progress view.
- **54 authored demonstration lessons across 18 units**, with explanations, concept checks, rehearsal prompts, and reflection.
- User-initiated live camera preview on supported web, iOS, Android, and macOS configurations, with self-review and unavailable/permission handling.
- Local lesson completion, saved signs, daily goals, sound preferences, activity minutes, and streaks. XP is awarded once per unique completed lesson; recorded activity uses actual whole minutes spent, not advertised lesson duration.
- A shared visual system, custom illustrations, branded platform icons, and layouts for phone and desktop.

This is an interactive product foundation. The seed curriculum awaits Deaf ASL educator review. It does **not** yet include a licensed, educator-verified signer-video course, automatic sign recognition or correction, live tutoring, cloud accounts, or a validated proficiency assessment. The camera provides self-guided practice: it does not determine whether a sign is correct. Illustrations are conceptual artwork, not authoritative sign demonstrations. Completion and XP measure participation, not fluency.

## Run locally

The project and CI use **Flutter 3.35.1 / Dart 3.9.0**. Apple builds require macOS, Xcode with the relevant platform support, and native plugin tooling. Run `flutter doctor -v` to inspect your environment.

```sh
flutter pub get
flutter run -d macos
```

For iOS Simulator, start a simulator, find its ID, and run the app:

```sh
open -a Simulator
flutter devices
flutter run -d <ios-simulator-device-id>
```

For web:

```sh
flutter run -d chrome
```

Camera access on web requires a supported browser and a secure context such as HTTPS or localhost. On native platforms, grant camera access when starting practice. An iOS Simulator can exercise the application and its unavailable-camera state; a physical iPhone is needed to validate real iOS capture. Windows camera support is not yet implemented.

## Verify and build

```sh
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/app_test.dart -d macos
flutter test integration_test/app_test.dart -d <ios-simulator-device-id>
flutter build web --release --pwa-strategy=none
flutter build macos --debug --target lib/main.dart
flutter build ios --simulator --debug --no-codesign --target lib/main.dart
```

Rebuild with `lib/main.dart` after a native integration test before distributing the local app bundle: integration tests build an app with the test entrypoint. Build outputs are `build/web`, `build/macos/Build/Products/Debug/nohasl.app`, and `build/ios/iphonesimulator/Runner.app`. Simulator/debug apps are development artifacts, not signed store releases.

The initial verification pass has **19 passing unit/widget tests**, passing integration flows on **macOS and iOS Simulator**, and a successful **web release build**. Browser navigation was exercised with keyboard and pointer, including persisted XP after reload. Tests cover persistence, idempotent XP, actual practice time, curriculum integrity, lesson interaction, and responsive layout. Android and Windows have not been built or run locally. Physical iOS camera testing, Android/Windows runtime validation, store signing, and educator validation remain separate release gates.

[GitHub Actions](.github/workflows/ci.yml) runs formatting, analysis, unit/widget tests, and a web build on Linux. Its macOS job builds the desktop app, executes the integration test, rebuilds the normal app entrypoint, builds the iOS Simulator app, and uploads the development artifacts. Separate jobs build an Android debug APK using JDK 17 and a Windows debug app. These workflows are configured; their first remote run is still required. CI does not claim to test real camera hardware.

## Product and engineering notes

- [Product plan](docs/PRODUCT_PLAN.md): learning journey, proposed full program, practice modes, stories, content production, assessment research, accessibility, and phased acceptance gates.
- [Architecture](docs/ARCHITECTURE.md): implemented foundation, proposed content/data contracts, platform adapters, camera lifecycle, recognition interfaces, privacy, and testing strategy.
- [Validation report](docs/VALIDATION.md): exact checks, tested platforms, screenshots and remaining device QA.
- [Camera implementation](docs/CAMERA.md): supported providers, permissions, self-review and lifecycle.
- [Curriculum](docs/CURRICULUM.md): the current lesson sequence, editorial limitations, sources, and Deaf-led review requirements.

Instructional quality depends on compensated Deaf educators, authentic licensed signer media, cultural review, and learning evaluation. The roadmap proposes a 288-lesson core program with receptive and expressive practice, contextual grammar, adaptive review, advanced narratives, and human conversation; those are planned production capabilities, not claims about the current seed content.

## Regenerate app icons

The monogram is drawn from vector paths by a small macOS Swift script. It generates every existing iOS/macOS app icon size, Android launcher PNGs, web icons/favicon, and a multi-resolution Windows ICO without third-party image dependencies:

```sh
swift tools/generate_icons.swift
```

The iOS app icons are opaque so the platform can apply its own mask; desktop/Android icons use rounded ink tiles, and web maskable icons keep the mark inside a safe central area.

## Preview

![nohasl on macOS](docs/screenshots/macos.png)

[Web screenshot](docs/screenshots/web.png) · [iPhone simulator screenshot](docs/screenshots/ios.png)
