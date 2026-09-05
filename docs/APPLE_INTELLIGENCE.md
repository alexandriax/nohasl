# On-device conversation coaching

nohasl uses Apple's **Foundation Models** framework for optional, freeform conversation rehearsal on eligible Apple devices. It creates short **English text scenarios** and conversational prompts. It does not translate English into ASL, demonstrate individual signs, inspect a camera, evaluate signing, or certify fluency. The camera mirror remains a separate, local self-review tool.

There is no automatic cloud fallback, account requirement, API key, HTTP request, frame upload, or conversation persistence in this integration. Unavailable devices can use the app's authored guided conversations. Apple manages the system model and its download separately from this app.

## Availability

Both runners register `nohasl/apple_intelligence`. The integration is compiled with `#if canImport(FoundationModels)` and runtime-gated with `#available(iOS 26.0, macOS 26.0, *)`. Existing older OS deployment targets stay intact.

The native `SystemLanguageModel.default.availability` value maps to:

| Dart status | Meaning |
| --- | --- |
| `available` | The on-device model can accept a request. |
| `deviceNotEligible` | The device cannot use the model; a supported OS alone is insufficient. |
| `appleIntelligenceNotEnabled` | Apple Intelligence needs to be enabled in system settings. |
| `modelNotReady` | The system is still preparing/downloading the model or otherwise cannot use it yet. |
| `unsupportedOS` | The framework or required OS version is absent. |
| `unsupportedPlatform` | The Dart client is running on web, Android, Windows, or Linux. No channel call is made. |
| `unavailable` | An unknown native reason or missing bridge; authored practice remains available. |

Check availability when entering the feature and offer a way to recheck it. It can change while the app is running. Generation also checks it natively immediately before a request. Availability is a capability check, not a request to enable or download Apple Intelligence.

## Dart contract

`lib/features/conversation/apple_intelligence.dart` exposes:

```dart
final service = AppleIntelligenceService();
final state = await service.availability();
if (state.isAvailable) {
  final turn = await service.respond(
    topic: 'At a cafe',
    level: 'Beginner',
    message: 'Hello, I would like a tea please.',
    history: const [],
  );
  // Display turn.reply and turn.followUpQuestion as the partner's turn.
  // turn.suggestedReply is an optional learner response.
  // turn.practiceGoal is a self-review prompt, never a correctness score.
}
await service.reset();
```

`ConversationMessage(role: 'user' | 'assistant', content: ...)` contains recent conversation text. `ConversationTurn` has four required string fields: `reply`, `suggestedReply`, `practiceGoal`, and `followUpQuestion`. `AiServiceException` provides a stable `code` and a short recoverable explanation in `message`.

The client and native layer both constrain requests. Topic length is at most 120 characters, level at most 40, and the latest message 1–1,000 characters. Only the last six user/assistant messages are provided, each limited to 500 characters. Arbitrary `system` roles are rejected from history. The Dart UI should enforce these same input limits rather than waiting for a validation error.

## Model and context design

Each request creates a fresh `LanguageModelSession(model: .default, instructions: ...)` and supplies bounded recent history as JSON in its lower-priority prompt. Earlier history is intentionally omitted. This gives a predictable memory bound and avoids accumulating a native transcript until it exceeds the system context window. The UI can retain more display history in memory, but should explain that the coach only sees recent turns.

Static instructions define the coach's role and exclude ASL translation, signing assessment, invented human qualifications, and claims of seeing the learner. Topic, level, and conversation text remain prompt data and cannot supply privileged instructions. Default Apple guardrails remain enabled. No model tools are registered.

The model generates a native `@Generable` structure. Field order is deliberate: partner reply, partner question, optional learner answer, then self-review goal. This helps keep conversational roles distinct. `@Guide` descriptions ask for short text; the native and Dart boundaries reject empty/malformed output and responses over 200 words. Requests also include a 600-response-token cap as protection against runaway output. A failure to finish valid structured output is surfaced as a recoverable error instead of partial chat content.

The practice goal may suggest intent, pacing, taking turns, or noticing expression with signs the learner already knows. Generated text remains fallible and requires a clear AI label. Prompt rules and structured output do not prove linguistic accuracy. Fluency, sign formation, ASL grammar, and educational assessment require reviewed resources and qualified human feedback.

## Lifecycle, cancellation, and errors

The native bridge serializes requests on the main actor and permits one active generation. An overlapping request gets `busy`; it is never submitted concurrently to a session. Native generation has a 60-second deadline, and the client has a 65-second safeguard.

`reset` cancels the active task, resolves its pending channel result with `cancelled`, and invalidates its request generation. Late model output cannot reach a new conversation. The Dart client independently discards stale output after a reset and prevents a new request while reset is still being acknowledged. No native history remains between completed requests. The UI must clear its own in-memory display history when the learner starts over and call reset when leaving the feature.

Recoverable generation codes include `modelNotReady`, `busy`, `refused`, `unsupportedLanguage`, `contextLimit`, `invalidResponse`, `timeout`, `cancelled`, and `generationFailed`. These do not silently route to another model. Do not present system/model refusal as a failure by the learner.

The bridge is embedded in the existing iOS `AppDelegate.swift` and macOS `MainFlutterWindow.swift` so no fragile Xcode source registration is needed. Their marked bridge sections are identical and must be kept in sync. This is a small native adapter rather than a third-party Flutter model package.

## Verification

- `test/apple_intelligence_test.dart`: availability states, bounded history, unsupported-platform behavior, invalid inputs, native error mapping, overlapping requests, reset with stale output, missing bridge, and malformed output.
- `integration_test/apple_intelligence_native_test.dart`: real native channel registration and availability; when a model is available, structured generation for a non-private cafe prompt and native cancellation; otherwise typed unavailable-device behavior.
- Production model-core Swift compilation and real execution were verified on an Apple silicon Mac running macOS 26.5.1 with Xcode 26.6. Apple Intelligence reported `available` and generated a four-field cafe turn. Prompt refinement corrected an initial partner/learner role duplication. This is runtime evidence, not a broad quality evaluation.
- Both native runners compile with the Xcode 26.6 SDK. The native bridge integration test passed on macOS and on the iPhone 17 / iOS 26.5 simulator. This simulator reported `available` and successfully generated all four structured fields; native reset/cancellation also passed. Do not assume every simulator exposes a model: the same test accepts typed unavailability when appropriate. This environment's simulator result does not establish physical-iPhone performance or eligibility; an eligible physical device still needs QA.

Run native checks with:

```sh
flutter test test/apple_intelligence_test.dart
flutter test integration_test/apple_intelligence_native_test.dart -d macos
flutter test integration_test/apple_intelligence_native_test.dart -d <ios-simulator-id>
```

Before release, evaluate conversational consistency across levels/topics, ambiguity, adversarial instructions, unsupported requests, longer histories, and Apple model/OS updates. Add Deaf educator review for any generated practice suggestions before treating them as instructional content.

Primary references: [Foundation Models generation and availability](https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models), [guided generation](https://developer.apple.com/documentation/foundationmodels/generating-swift-data-structures-with-guided-generation), and [session API](https://developer.apple.com/documentation/foundationmodels/languagemodelsession). The implementation was checked against the locally installed Xcode 26.6 `FoundationModels.swiftinterface`; it does not depend on newer beta API names shown in some online documentation.
