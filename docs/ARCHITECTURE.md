# nohasl architecture

## Architecture boundary

nohasl uses one Flutter application for web, macOS, iOS, Android, and Windows. Web, macOS, and iOS are the first release targets. The current application is a local interactive foundation: curriculum data, lesson and story flows, local progress/preferences, and a self-guided camera studio. It does not yet ship an ASL recognition model, a backend, account synchronization, or an educator-verified signer-video catalog.

The sections marked **proposed** describe evolution of that foundation, not services already deployed. Product scope and review gates are in [PRODUCT_PLAN.md](PRODUCT_PLAN.md).

## Decisions

| Decision | Reason | Consequence |
|---|---|---|
| Flutter with platform-specific camera adapters | Shared polished interaction and domain logic with native desktop/mobile builds | Native permission, lifecycle, orientation, and performance tests remain necessary on each platform |
| Local state first | The first learning experience does not require account setup or a backend | Progress belongs to the local installation/browser profile; cross-device sync is later work |
| Real camera, self-review first | Provides useful expressive practice without falsely scoring language | Completion and self-confidence must not be called model accuracy or fluency |
| Curated content as data | Lessons, vocabulary, stories, and skill links can evolve independently from visual widgets | Future content needs stable IDs, versioning, reviewer approval, and migrations |
| Authentic reviewed signer media as the teaching source | Meaning includes hands, face, body, motion, and context | Vector illustration and animation support learning but cannot substitute for validated sign media |
| Recognition behind an explicit interface | Model feasibility, platform runtime, data rights, and accuracy are unresolved | UI must work when inference is unavailable, unsupported, or uncertain |
| No automatic camera upload | Keep practice simple and private by default | Saved recordings and cloud feedback require separate consent and implementation |

## Current layers

```text
Flutter application
├── Responsive navigation and visual system
├── Learning dashboard / curriculum / library / stories / progress
├── Lesson and practice presentation
│   └── Camera studio
│       ├── Mobile and web camera implementation
│       └── macOS camera implementation
├── Structured curriculum and story data
└── Local progress and settings persistence

Platform hosts
├── web: browser permissions and secure-origin requirements
├── macOS: native camera permission and sandbox entitlement
├── iOS: native camera purpose string and lifecycle handling
├── Android: generated target; release validation remains
└── Windows: generated target; camera adapter/validation remains
```

Keep teaching content and progress calculations out of custom painters and camera widgets. Camera access is a capability: missing hardware or permission does not prevent browsing or camera-free practice.

## Proposed modular structure

As features grow, organize by domain rather than splitting every small widget into its own abstraction:

```text
lib/
  app/                 App composition, routes, themes, responsive shell
  features/
    learning/          Lesson player and curriculum browsing
    practice/          Prompts, camera session, review and feedback
    stories/           Episode player and branch state
    library/           Search, vocabulary detail and bookmarks
    progress/          Practice history, skill evidence and review queue
    settings/          Accessibility, storage, consent and account options
  domain/              Stable content IDs, review events, assessment contracts
  data/                Bundled content and repository implementations
  platform/            Camera, media, audio, haptics and inference adapters
```

Views render state and dispatch actions. Controllers coordinate use cases. Repositories read and write content/progress. Platform adapters handle device APIs. Add state-management dependencies when the number of independent async domains justifies them; a local foundation does not require a service layer for every button.

## Proposed content contracts

Use stable IDs and explicit version fields; titles and list positions are not identity.

| Entity | Essential fields |
|---|---|
| CourseStage / Unit | ID, version, title, order, communicative outcomes, prerequisite skill IDs, lesson IDs |
| Lesson | ID, content version, target skills, prerequisites, estimated duration, activity IDs, cultural note, editorial state |
| Activity | ID, kind, prompt, stimulus media, response contract, feedback rubric, supported variants, accessibility alternative |
| SignConcept | ID, meaning/context, associated skill IDs, variant IDs, related/confusable concepts, region/register |
| SignVariant | ID, signer/media IDs, regional and usage metadata, dominant hand, annotation references, approval state |
| MediaAsset | ID, immutable content hash, rendition URLs, duration, dimensions, caption/scaffolding tracks, rights/reviewer references |
| StoryEpisode | ID, version, prerequisites, nodes, choices, response contracts, outcomes and review items |
| SkillEvidence | Skill ID, source activity/version, receptive/expressive/contextual dimension, assessor type, outcome, uncertainty, timestamp |
| ReviewItem | Skill/item ID, next due time, scheduler version, prior evidence, difficulty state, last exposure |

Publication must reject dangling references, unreachable story nodes, missing feedback, and unapproved instructional media. A content version is immutable after release; corrections produce a new version with migration rules. Mark removed or corrected items rather than silently changing the meaning of historical assessment.

### Progress event model

The proposed durable model is an append-only sequence of events such as `lessonStarted`, `answerSubmitted`, `practiceSelfReviewed`, `lessonCompleted`, `bookmarkChanged`, and `goalChanged`. Store UTC time, event ID, content version, and source. Derive views such as completion and review due from evidence. This makes future offline sync and reconciliation tractable.

Completion and mastery are different data fields. Only an assessment with an identified rubric and assessor can add assessed evidence. A timer, camera stream, or activity-completion button cannot create it. Practice completion should be idempotent where it awards a one-time milestone; repeated attempts can still add separate practice history.

The initial store awards XP once per unique lesson ID. Completed attempts add `floor(activeSeconds / 60)` minutes to the local calendar day, using actual elapsed time passed by the lesson player. Attempts below 60 seconds create no activity entry and no streak day; repeated completion can add time without duplicating XP. These are participation measures, and fractional minutes are currently discarded per attempt.

For the current small local dataset, preferences-backed persistence is sufficient. Migrate to a versioned local database when review events, offline media, or sync require transactional updates. Plan corruption recovery, schema upgrades, local data reset/export, and tests before treating local progress as durable across app upgrades.

## Camera session lifecycle

Model the studio as explicit states:

```text
idle → requestingPermission → initializing → previewing
                     └──────→ denied / restricted / unavailable / failed
previewing → paused → previewing
previewing / paused / initializing → stopping → idle
```

Requirements:

- Request only after a user's start action; show permission intent first.
- Handle absent camera, denied permission, OS-level restriction, device contention, initialization timeout, unsupported platform, and start/stop races.
- Dispose controllers and stop all native tracks when leaving the studio or deactivating the application. Ignore late asynchronous initialization after disposal.
- Keep the full signing space visible. Favor a stable front-camera preview with aspect-ratio-preserving crop controls.
- Separate preview mirroring from analysis coordinates and saved-media orientation. Transform landmarks consistently and retain real handedness metadata.
- Make start, stop, switch-camera, retry, and recovery reachable with keyboard and assistive technology. A camera-free route remains usable.
- Default microphone capture off. Optional narrated instruction or sound cues do not require microphone permission.

An iOS Simulator can verify layouts, navigation, and unavailable-camera behavior. A simulator build or launch cannot establish real iPhone camera quality. Flutter also recommends testing on physical iOS hardware in its [iOS setup guidance](https://docs.flutter.dev/platform-integration/ios/setup).

## Proposed perception and assessment architecture

```text
Camera frame + timestamp
    ↓
Capture quality gate: visibility, framing, exposure, blur, occlusion
    ↓
On-device hand + face + upper-body feature extraction
    ↓
Coordinate normalization + handedness + temporal window
    ↓
Task-specific temporal model + supported variant set
    ↓
Confidence calibration + out-of-distribution / abstention checks
    ↓
Educator-authored feedback mapping
    ↓
Specific observation OR unable-to-assess result
```

This is a design proposal, not an implemented inference pipeline. [MediaPipe Hand Landmarker](https://ai.google.dev/edge/mediapipe/solutions/vision/hand_landmarker) provides hand landmarks and handedness; it is only a possible component of the feature extractor. Face and body features, continuous motion, language context, and independent model validation are additional work.

### Interface semantics

```text
AssessmentRequest
  activityId, contentVersion, expectedConcepts, acceptedVariants
  targetRubric, frame/features stream, consent, deviceCapabilities

AssessmentResult
  status: supported | uncertain | unsupported | insufficientCapture
  rubricObservations: feature, observation, uncertainty, evidenceWindow
  modelVersion, rubricVersion, elapsedTime
```

Do not expose a universal “ASL accuracy” field. Recognition of an isolated target is not sentence correctness or conversational proficiency. Capture quality is not learner quality. The default for an unavailable or unvalidated model is `unsupported`, followed by self-review.

### Runtime choices to evaluate

- iOS/macOS: native platform code or a supported inference runtime behind typed Flutter bridges; benchmark Apple hardware without assuming acceleration is available everywhere.
- Web: a worker-based vision/inference adapter where supported; use feature detection and measured device budgets. Keep UI rendering and camera controls responsive.
- Android: a native adapter or supported mobile runtime, tested across representative midrange hardware.
- Windows: a camera implementation plus a supported desktop inference runtime; no promise of parity until it passes the same test matrix.

Prototype candidates against actual camera streams, supported targets, binary/model size, memory, energy use, maintenance burden, and licensing. Choose a runtime only after the benchmark. A server fallback is optional future work with explicit video/feature-sharing consent; offline self-review always remains available.

### Validation gates

- Use consented, licensed, educator-labeled data with separate training rights.
- Split by signer and session, not random frames. Maintain an external holdout and examples from outside supported vocabulary.
- Report false-correction, false-acceptance, uncertainty, and abstention rates alongside aggregate recognition metrics.
- Evaluate relevant skin tones, lighting, backgrounds, handedness, speeds, regional variants, devices, and mobility differences; publish limitations and unsupported categories.
- Predeclare thresholds with educators based on harm from wrong feedback. Do not choose a launch threshold after observing the held-out result.
- Version models and rubrics; allow remote rollback of a model without removing camera practice. Keep human/self-review fallbacks.

## Proposed media, sound, and animation

Reviewed videos are the canonical demonstrations. Provide stable full-frame playback, natural speed, useful slower speed, looped segments, caption/scaffolding controls, and visible orientation labeling. Side-by-side camera mode must not hide the model's face or relevant signing space.

Use vector illustration for story environments, navigation, conceptual diagrams, and transitions. Instructional motion overlays require educator validation and must line up with the real filmed performance. Respect reduced-motion settings. Haptics and optional sounds reinforce visible state; instruction and timing remain comprehensible with sound disabled.

Downloadable lesson packages should use a manifest with immutable content hashes, rights metadata, rendition sizes, and explicit user storage controls. Never silently cache user camera frames with downloaded instructional media.

## Proposed services and synchronization

Add a backend only when accounts, paid content, instructor review, or sync need it. Separate content delivery from personal data:

- **Content service/CDN:** approved versioned manifests and licensed media, with signed authoring releases.
- **Progress service:** authenticated event ingestion and idempotent replay, with per-user authorization and export/delete endpoints.
- **Editorial tools:** drafts, media rights, review history, publishing checks, content corrections, and rollback.
- **Optional review service:** separately consented recordings, scoped educator access, retention enforcement, and annotation.
- **Optional analytics:** aggregate behavior without camera frames, signed content of a learner's response, or sensitive movement features.

Offline actions get unique event IDs. Sync retries must not duplicate completion rewards. Keep local pending events until acknowledged, reconcile content-version conflicts explicitly, and test signing out while offline. Avoid last-write-wins for independent practice events; settings can use per-field conflict rules.

## Platform and quality matrix

| Area | Web | macOS | iOS | Android / Windows |
|---|---|---|---|---|
| Build | Release web bundle in Linux CI | Native debug app in macOS CI | Debug simulator app in macOS CI | Android debug APK / Windows debug app jobs configured; first remote run pending |
| Interaction | Pointer, touch, keyboard, resizing | Native window resizing, keyboard, focus | Touch, portrait/landscape, safe areas, dynamic text | Same shared flows plus platform conventions |
| Camera | Secure origin, grant/deny, browser tab lifecycle | Permission + entitlement, device changes, backgrounding | Physical front camera, interruptions, rotation, backgrounding | Adapter support, permission, lifecycle and orientation |
| Accessibility | Browser semantics and screen reader | VoiceOver and full keyboard access | VoiceOver, text scaling, reduced motion | TalkBack/Narrator and equivalent testing |
| Release | HTTPS hosting and cache behavior | Signing/notarization and distribution | Physical-device build, signing, TestFlight | Packaging, signing, store distribution |

The workflow in [.github/workflows/ci.yml](../.github/workflows/ci.yml) pins Flutter 3.35.1 and configures analysis, unit/widget tests, the macOS integration flow, and web, macOS, iOS Simulator, Android debug APK, and Windows debug artifacts. It rebuilds the normal macOS entrypoint after integration tests before packaging. iOS integration testing runs against a selected local simulator; CI only builds the simulator app. The Android/Windows jobs still require a first remote run and local runtime validation. A passing build is compilation evidence; it does not by itself demonstrate interactive or hardware-camera testing.

### Local verification commands

```sh
flutter --version
flutter doctor -v
flutter pub get
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter build web --release
flutter build macos --debug
flutter build ios --simulator --debug --no-codesign
flutter devices
flutter run -d macos
flutter run -d <ios-simulator-device-id>
```

When integration tests are present, run `flutter test integration_test/app_test.dart -d macos` and then the equivalent using the selected iOS Simulator device ID. Flutter's `integration_test` cannot operate native permission dialogs; use a native-capable test harness or a documented manual pass for those paths. See the official [testing overview](https://docs.flutter.dev/testing/overview) and [integration-test guide](https://docs.flutter.dev/testing/integration-tests).

### Meaningful test coverage

- Navigation and lesson flow: select an answer, see appropriate feedback, advance, complete once, and return to a consistent learning state.
- Data and progress: stable IDs, valid curriculum references, branch reachability, no duplicated first-completion rewards, persistence reload, and goal/bookmark changes.
- Responsive layouts: compact phone width, wide desktop, landscape, large text, scrolling, and no inaccessible clipped actions.
- Camera state: no request before intent, permission denial, unavailable device, initialization error, rapid stop/navigation, and resource disposal.
- Future scheduler: delayed recall rules, time-zone/day boundaries, clock changes, version migrations, and bounded review workload.
- Future assessment: uncertain/unsupported responses never become “correct”; accepted variants, held-out signer performance, and unsupported capture conditions.

### Release evidence

Record SDK/Xcode versions, commit, device/OS/browser, build command, actual launch, tested flows, camera hardware result, screenshots, and unresolved failures. Never conflate “project target exists,” “compiled,” “launched,” “automated tests passed,” and “hardware-tested.” Physical camera testing, store signing, curriculum validation, and model validation are separate release gates.
