# Camera practice

`CameraStage(signWord: 'HELLO')` is a real local camera mirror with an explicit **Start camera** action. The current feedback is labeled **Mirror practice · self review**. There is no sign recognition, automatic accuracy score, recording, microphone capture, storage of frames, or upload.

The learner frames their face and both hands, starts a three-second preparation countdown, practices for twelve seconds, and reflects on handshape/orientation, location/movement, and expression. The timer can be finished early. Camera-free practice provides the same reflection workflow. This flow does not certify that a sign is correct or that the learner has mastered it.

## Platform implementation

| Platform | Provider | Current behavior |
| --- | --- | --- |
| iOS | Flutter `camera` / AVFoundation | Front camera preferred, live preview, device switching, permission recovery guidance |
| macOS | `camera_macos` 0.1.1 | AVKit camera texture, explicit session lifecycle and cleanup, camera switching |
| Web | Flutter `camera` / `camera_web` | Browser camera preview; HTTPS or localhost required |
| Android | Flutter `camera` / CameraX | Preview implementation included; minimum API 24 |
| Windows / Linux | No native provider configured | Friendly fallback to web camera practice or camera-free practice |

The camera opens only after a button press. Audio is explicitly disabled. Front camera providers normally supply a mirrored preview; the flip control lets learners reverse it. The macOS provider is initialized with `isVideoMirrored: true`. Use a known asymmetric gesture during physical-device QA to verify each provider's actual presentation. The framing illustration is decorative and is never a sign demonstration.

Camera sessions are released when the widget is disposed, the user turns the camera off, or the app is backgrounded. Resuming does not silently restart the camera. Initialization attempts are serialized to avoid a stale macOS permission request destroying a newer session. Native camera permission dialogs can temporarily make an app inactive; the pending request is not canceled for that transition alone.

`camera_macos` 0.1.1 loses its native permission error during device discovery and returns an invalid-response error. The UI handles that case with both permission and device-connection guidance. This provider is a community package and should receive a native integration audit before a production release.

## Native setup

- iOS and macOS include `NSCameraUsageDescription` with a specific local-practice explanation.
- Both macOS debug/profile and release entitlement files include `com.apple.security.device.camera`.
- Android declares camera permission and an optional camera hardware feature. Camera-free learning remains available without hardware.
- No microphone entitlement or permission description is added because audio capture is disabled. If future features enable audio recording, add the corresponding permissions and explicit consent at that time.
- iOS simulators do not provide a real camera. Exercise the empty-device state there and verify preview, orientation, and permission flows on physical iPhone/iPad hardware.
- Web needs HTTPS in production; a plain remote HTTP origin will not provide a camera permission prompt.

## Recognition extension boundary

Recognition must be a separate opt-in service; the practice UI must never fabricate a correctness score to stand in for it. Keep preview/lifecycle in a `CameraSession` adapter and introduce these boundaries when the first validated model is ready:

1. **Frame source:** timestamped frame input with dimensions, pixel format, sensor rotation, and whether the preview is mirrored. Process local frames in bounded queues and dispose them immediately. Native frame streaming is supported by the mobile and Mac providers. The current web camera provider has no frame-stream API, so a browser MediaStream / video-frame adapter is required there.
2. **Landmark engine:** on-device hands, pose, face, and confidence estimates; explicit insufficient-light/out-of-frame results. A handshape classifier alone cannot evaluate ASL fluency.
3. **Task evaluator:** compare only the lesson's validated assessment targets, accounting for handedness, linguistic variation, transitions, facial grammar, and timing. Return uncertainty and actionable observations, with no penalty when the model cannot assess.
4. **Learning evidence:** distinguish self-report, model observations, and human educator review in stored progress. Do not use a practice timer or checklist as evidence of fluency.
5. **Validation:** Deaf ASL educators review prompts, modeling, feedback, and errors. Evaluate across skin tones, lighting, camera quality, handedness, signing styles, mobility differences, and regional variation before shipping scored feedback.

Keep frame transmission off by default. Any future teacher video submission must require separate, specific consent and clear retention/deletion controls. The current mirror does not need a backend.

## Verification

`test/camera_stage_test.dart` verifies consent-first initialization, audio disabled, native teardown, denied permission recovery, no-camera fallback, and the full countdown/self-review flow using a mocked native channel. These tests verify app behavior, not physical camera fidelity. Release QA must exercise a real Mac camera and a physical iOS device, including denial, revocation, switching, background/resume, navigation away, orientation changes, and camera contention.

Primary references (reviewed September 2026): [Flutter camera](https://pub.dev/packages/camera), [camera web](https://pub.dev/packages/camera_web), [camera_macos](https://pub.dev/packages/camera_macos), and [camera_macos source](https://github.com/riccardo-lomazzi/camera_macos).
