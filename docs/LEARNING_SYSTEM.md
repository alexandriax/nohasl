# Learning, retrieval, and reflection

The expanded learning system adds a real local review queue and written self-review portfolio to lesson completion. It schedules future retrieval, preserves expressive and receptive practice separately, and records what the learner reports. It does not infer correct signing, language proficiency, or teacher approval from a camera session, a rating, or a completed lesson.

## Implemented components

- [review_scheduler.dart](../lib/state/review_scheduler.dart): immutable review/evidence models, validated serialization, and a deterministic interval heuristic.
- [learning_store.dart](../lib/state/learning_store.dart): persistent queue, completion-triggered review prompts, bounded due sessions, self-review history, version-one migration, and progress/preferences.
- [practice_activities.dart](../lib/data/practice_activities.dart): 24 contextual activities, four per product level. Twenty-one contain a conceptual multiple-choice check with explanatory feedback; three use open reflection. All contain objectives, instructions, a camera-rehearsal task, three self-review criteria, and concept identifiers.

The activity catalog includes spatial scenes, number messages, fingerspelled names, nonmanual reflection, memory, narrative retelling, two-role information-gap rehearsal, discussions, conversational follow-ups, and portfolio reflection. These are authored exercises pending Deaf educator review. Text-based concept checks are not signed-video comprehension tests. Solo role rehearsal is preparation for interaction, not equivalent to spontaneous conversation with another person.

## Review identities and creation

Each review item has a stable ID derived from its concept ID and `ReviewDomain` (`expressive` or `receptive`). Normalization trims surrounding whitespace and lowercases the identity. The same concept can have independent schedules in both domains.

On a lesson's first completion, the store enqueues its `conceptIds`, falling back to the lesson ID for legacy lessons without tags. A `comprehension` lesson creates receptive review prompts; other lessons create expressive prompts. Repeated lesson completion or repeated concept exposure never resets an existing schedule. Completion still awards XP once per unique curriculum lesson.

New items are immediately due. A caller can also use `addReview` with a specific domain, prompt, source lesson, and optional due time. Empty concepts/prompts do not create queue items. Each item's prompt identifies what to retrieve and asks the learner to compare with the lesson or a trusted signer reference. Until reviewed media is available, a receptive-tagged concept exercise must not be presented as a measured signed-language comprehension result.

## Scheduling policy

`scheduleReview(item, rating, now)` is a pure function. It neither reads a clock nor mutates the input. Dates are stored as UTC instants. Scheduling starts from the actual review time, with no reward or penalty based on how overdue an item is.

| Self-rating | New item | Existing interval | Repetition/lapse behavior |
|---|---|---|---|
| Again | Retry in 10 minutes | Retry in 10 minutes; stored interval becomes 0 days | Reset repetitions to 0; increment lapses |
| Hard | 1 day | Round up previous days × 1.2 | Increment repetitions |
| Good | 1 day | Previous days × 2 | Increment repetitions |
| Easy | 4 days | Round up previous days × 2.5 | Increment repetitions |

All successful intervals are capped at 90 days. A successful attempt after an `Again` restart uses the new-item interval. Repetitions count successful self-ratings since the latest lapse; they are not a proficiency score.

This is `nohasl-heuristic-v1`: an explicit product rule chosen for a useful, predictable first implementation. It is **not FSRS**, a trained memory model, or a validated predictor of retention. Before adopting a more sophisticated scheduler or claiming learning effectiveness, run an appropriately designed delayed-recall evaluation with educators and learners.

`reviewQueue` exposes a read-only list sorted by due time and then ID. `dueReviews` returns at most ten items; `dueReviewCount` counts all currently due items. `dueReviewsAt(now, limit: ...)` supports deterministic tests and a custom bounded session, with a hard ceiling of 50. Items beyond the visible session remain queued. Rating one item updates only that domain's schedule.

## Evidence portfolio

`PracticeEvidence` stores:

- A unique entry ID, activity ID, title, and domain.
- The UTC creation time and actual active seconds supplied by the caller.
- The learner's written reflection, a snapshot of the exercise's rubric labels, and an optional retrieval rating.
- An explicit self-reported source label.

The stored rubric is a set of reflection prompts, not scored or teacher-approved criteria. No camera video, camera frames, landmarks, recognition score, or conversation transcript is saved by this system. Entries are presented newest first. `recordReview` adds an entry as it updates the schedule; `addEvidence` supports an explicitly finished practice or conversation activity.

Active seconds are stored as nonnegative values. As in the original app, daily activity accumulates whole minutes, rounded down **per finished attempt**. An attempt under 60 seconds does not create an activity day or streak. Repeated practice can add time, while XP remains tied to unique curriculum completion. Camera use alone does not create evidence, time, or XP.

## Persistence and migration

The app keeps the existing SharedPreferences key, `nohasl.v1`, so installed version-one learners retain their data. The JSON payload now includes `version: 2`, `scheduler: nohasl-heuristic-v1`, `reviews`, and `evidence` alongside existing completion, bookmarks, goal, sound, and daily activity fields.

When reading a version-one payload, the store preserves valid completion IDs, bookmarks, settings, and activity, then creates review prompts for completed lessons. It does not invent historical review attempts or add time/XP. The next successful mutation persists the upgraded payload. The expanded curriculum preserves the original 54 lesson IDs so their completion can survive the new course structure.

Individual invalid review/evidence records are skipped and reported through `storageError`; valid records and unrelated progress remain available. Malformed field types are isolated where possible. A completely unreadable JSON payload starts with empty learning state and exposes the error. A subsequent successful save can recover the payload. Writes are serialized so an older asynchronous save cannot overwrite a newer reflection or schedule.

Reset clears completed lessons, bookmarks, activity, review queue, and evidence, while keeping the learner's goal and sound preferences. There is no cloud account or cross-device sync in this store. Browser storage clearing or app-data removal can erase local progress. A database, export/import, and optional authenticated synchronization remain future work.

## API for presentation code

```dart
await store.addReview(
  conceptId: 'spatial-reference',
  prompt: 'Describe a familiar room from one consistent viewpoint.',
  domain: ReviewDomain.expressive,
);

final due = store.dueReviews;
if (due.isNotEmpty) {
  await store.recordReview(
    due.first.id,
    ReviewRating.hard,
    reflection: 'I lost track of the lamp when I changed viewpoint.',
    rubric: ['Stable viewpoint', 'Clear referents'],
    activeSeconds: 125,
  );
}

await store.addEvidence(
  activityId: 'desk-map',
  title: 'Rebuild my desk',
  reflection: 'Next time I will establish the notebook first.',
  rubric: ['Introduce objects', 'Maintain viewpoint'],
  activeSeconds: 90,
);
```

The presentation layer should explain that ratings describe the learner's experience, make self-review explicit, and offer an opportunity to revisit a trusted reference. It should not translate a count of entries or successful ratings into a fluency percentage. Record time only once for a finished activity; do not call both recording methods with the same elapsed duration for one event.

## Verification

The focused suite currently has 26 passing tests: 18 store tests and eight scheduler/catalog tests. It checks the original persistence/time/XP behavior, queue deduplication, separate domains, due ordering and limits, deterministic intervals, UTC offsets, maximum intervals, v1 migration, corrupt-record salvage, concurrent evidence writes, reset, and playable catalog structure.

```sh
flutter test test/learning_store_test.dart test/review_scheduler_test.dart
dart analyze lib/state/learning_store.dart lib/state/review_scheduler.dart lib/data/practice_activities.dart
```

These tests verify application behavior and data integrity. They do not establish instructional accuracy, retention benefit, sign-recognition performance, or real-world proficiency.
