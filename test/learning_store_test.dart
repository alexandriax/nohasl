import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/data/curriculum.dart';
import 'package:nohasl/state/learning_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<LearningStore> createStore({
    String? serialized,
    DateTime Function()? clock,
  }) async {
    SharedPreferences.setMockInitialValues({
      if (serialized != null) 'nohasl.v1': serialized,
    });
    final preferences = await SharedPreferences.getInstance();
    final store = LearningStore(preferences, clock: clock);
    addTearDown(store.dispose);
    return store;
  }

  test('a new learner starts with no invented progress', () async {
    final store = await createStore();

    expect(store.completed, isEmpty);
    expect(store.saved, isEmpty);
    expect(store.xp, 0);
    expect(store.todayMinutes, 0);
    expect(store.streak, 0);
    expect(store.nextLesson.id, starterLesson.id);
    expect(store.storageError, isFalse);
  });

  test(
    'a short completion records practice without inventing a streak',
    () async {
      final store = await createStore();

      await store.complete(starterLesson, activeSeconds: 59);

      expect(store.completed, contains(starterLesson.id));
      expect(store.xp, starterLesson.xp);
      expect(store.activity, isEmpty);
      expect(store.todayMinutes, 0);
      expect(store.streak, 0);
    },
  );

  test(
    'activity uses actual whole minutes rather than advertised time',
    () async {
      final store = await createStore();

      await store.complete(starterLesson, activeSeconds: 125);

      expect(store.todayMinutes, 2);
      expect(store.activity.values, [2]);
      expect(store.streak, 1);
    },
  );

  test('repeating a lesson adds practice time but awards XP once', () async {
    final store = await createStore();

    await store.complete(starterLesson, activeSeconds: 120);
    await store.complete(starterLesson, activeSeconds: 180);

    expect(store.completed, {starterLesson.id});
    expect(store.xp, starterLesson.xp);
    expect(store.todayMinutes, 5);
  });

  test('progress, bookmarks, and preferences survive a store reload', () async {
    final store = await createStore();
    await store.complete(starterLesson, activeSeconds: 180);
    await store.toggleSaved('hello');
    await store.setGoal(15);
    await store.setSound(true);

    final reloaded = LearningStore(store.preferences);
    addTearDown(reloaded.dispose);

    expect(reloaded.completed, {starterLesson.id});
    expect(reloaded.xp, starterLesson.xp);
    expect(reloaded.todayMinutes, 3);
    expect(reloaded.saved, {'hello'});
    expect(reloaded.dailyGoal, 15);
    expect(reloaded.sound, isTrue);
    expect(reloaded.storageError, isFalse);
    expect(reloaded.nextLesson.id, isNot(starterLesson.id));
  });

  test(
    'unsaving is persisted rather than only updating the current view',
    () async {
      final store = await createStore();
      await store.toggleSaved('hello');
      await store.toggleSaved('hello');

      final reloaded = LearningStore(store.preferences);
      addTearDown(reloaded.dispose);

      expect(reloaded.saved, isEmpty);
    },
  );

  test(
    'reset removes learning history while preserving user preferences',
    () async {
      final store = await createStore();
      await store.complete(starterLesson, activeSeconds: 180);
      await store.toggleSaved('hello');
      await store.setGoal(20);
      await store.setSound(true);
      await store.reset();

      final reloaded = LearningStore(store.preferences);
      addTearDown(reloaded.dispose);

      expect(reloaded.completed, isEmpty);
      expect(reloaded.saved, isEmpty);
      expect(reloaded.activity, isEmpty);
      expect(reloaded.xp, 0);
      expect(reloaded.streak, 0);
      expect(reloaded.nextLesson.id, starterLesson.id);
      expect(reloaded.dailyGoal, 20);
      expect(reloaded.sound, isTrue);
    },
  );

  test('streak continues from yesterday but stops at the first gap', () async {
    final now = DateTime.now();
    String day(int offset) {
      final date = DateTime(now.year, now.month, now.day - offset);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }

    final store = await createStore(
      serialized: jsonEncode({
        'activity': {day(1): 4, day(2): 7, day(4): 10},
      }),
    );

    expect(store.todayMinutes, 0);
    expect(store.streak, 2);

    await store.complete(starterLesson, activeSeconds: 60);
    expect(store.streak, 3);
  });

  test('stale lessons and invalid activity do not create progress', () async {
    final store = await createStore(
      serialized: jsonEncode({
        'completed': ['removed-lesson', 123],
        'goal': 999,
        'activity': {'2026-01-01': 0, '2026-01-02': -2},
      }),
    );

    expect(store.completed, isEmpty);
    expect(store.xp, 0);
    expect(store.activity, isEmpty);
    expect(store.dailyGoal, 10);
  });

  test('corrupt local JSON is surfaced and a new save can recover', () async {
    final store = await createStore(serialized: '{broken json');

    expect(store.storageError, isTrue);
    expect(store.completed, isEmpty);

    await store.setGoal(5);

    expect(store.storageError, isFalse);
    final reloaded = LearningStore(store.preferences);
    addTearDown(reloaded.dispose);
    expect(reloaded.storageError, isFalse);
    expect(reloaded.dailyGoal, 5);
  });

  test(
    'lesson completion enqueues concepts once and preserves their schedule',
    () async {
      final now = DateTime.utc(2026, 9, 5, 12);
      final store = await createStore(clock: () => now);
      await store.complete(starterLesson, activeSeconds: 65);
      final ids = store.reviewQueue.map((r) => r.id).toSet();
      expect(ids, isNotEmpty);
      final first = store.reviewQueue.first;
      await store.recordReview(first.id, ReviewRating.easy);
      await store.complete(starterLesson, activeSeconds: 65);

      expect(store.reviewQueue.map((r) => r.id).toSet(), ids);
      expect(
        store.reviewQueue.firstWhere((r) => r.id == first.id).dueAt,
        now.add(const Duration(days: 4)),
      );
      expect(store.xp, starterLesson.xp);
    },
  );

  test('expressive and receptive recall keep independent evidence', () async {
    final now = DateTime.utc(2026, 9, 5, 12);
    final store = await createStore(clock: () => now);
    await store.addReview(conceptId: 'greeting', prompt: 'Try your greeting.');
    await store.addReview(
      conceptId: 'greeting',
      prompt: 'Recall the meaning.',
      domain: ReviewDomain.receptive,
    );
    final expressiveId = ReviewItem.keyFor('greeting', ReviewDomain.expressive);
    await store.recordReview(
      expressiveId,
      ReviewRating.good,
      reflection: 'I remembered the intention; I will check the movement.',
    );

    expect(store.reviewQueue, hasLength(2));
    expect(store.dueReviews.single.domain, ReviewDomain.receptive);
    expect(store.evidence.single.domain, ReviewDomain.expressive);
    expect(store.evidence.single.source, 'Self-reported practice');
    expect(store.xp, 0);
  });

  test('due reviews are stable, bounded, and exclude future items', () async {
    final now = DateTime.utc(2026, 9, 5, 12);
    final store = await createStore(clock: () => now);
    for (var i = 0; i < 14; i++) {
      await store.addReview(
        conceptId: 'concept-$i',
        prompt: 'Recall $i.',
        dueAt: now.subtract(Duration(minutes: i)),
      );
    }
    await store.addReview(
      conceptId: 'tomorrow',
      prompt: 'Later.',
      dueAt: now.add(const Duration(days: 1)),
    );

    expect(store.dueReviewCount, 14);
    expect(store.dueReviews, hasLength(10));
    expect(store.dueReviews.first.conceptId, 'concept-13');
    expect(store.dueReviewsAt(now, limit: 3), hasLength(3));
    expect(store.dueReviewsAt(now, limit: -1), isEmpty);
    expect(store.reviewQueue, hasLength(15));
  });

  test(
    'version one progress migrates without inventing review evidence',
    () async {
      final now = DateTime.utc(2026, 9, 5, 12);
      final store = await createStore(
        clock: () => now,
        serialized: jsonEncode({
          'completed': [starterLesson.id],
          'saved': ['hello'],
          'goal': 15,
          'activity': {'2026-09-04': 8},
        }),
      );

      expect(store.completed, {starterLesson.id});
      expect(store.xp, starterLesson.xp);
      expect(store.reviewQueue, isNotEmpty);
      expect(store.evidence, isEmpty);
      expect(store.todayMinutes, 0);
      expect(store.streak, 1);
      await store.setSound(true);
      final serialized =
          jsonDecode(store.preferences.getString('nohasl.v1')!) as Map;
      expect(serialized['version'], 2);
      final reloaded = LearningStore(store.preferences, clock: () => now);
      addTearDown(reloaded.dispose);
      expect(reloaded.reviewQueue.length, store.reviewQueue.length);
      expect(reloaded.evidence, isEmpty);
      expect(reloaded.saved, {'hello'});
    },
  );

  test(
    'review rating and reflection survive reload with actual time',
    () async {
      final now = DateTime.utc(2026, 9, 5, 12);
      final store = await createStore(clock: () => now);
      await store.addReview(
        conceptId: 'spatial',
        prompt: 'Describe the scene.',
      );
      final item = store.reviewQueue.single;
      await store.recordReview(
        item.id,
        ReviewRating.again,
        reflection: 'I lost track of the cup.',
        rubric: ['Stable viewpoint', 'Clear referents'],
        activeSeconds: 125,
      );
      final reloaded = LearningStore(store.preferences, clock: () => now);
      addTearDown(reloaded.dispose);

      expect(reloaded.reviewQueue.single.lapses, 1);
      expect(
        reloaded.reviewQueue.single.dueAt,
        now.add(const Duration(minutes: 10)),
      );
      expect(reloaded.evidence.single.rating, ReviewRating.again);
      expect(reloaded.evidence.single.reflection, 'I lost track of the cup.');
      expect(reloaded.evidence.single.rubric, [
        'Stable viewpoint',
        'Clear referents',
      ]);
      expect(reloaded.evidence.single.activeSeconds, 125);
      expect(reloaded.todayMinutes, 2);
      expect(reloaded.xp, 0);
    },
  );

  test(
    'corrupt review entries do not erase valid progress or queue entries',
    () async {
      final now = DateTime.utc(2026, 9, 5, 12);
      final valid = ReviewItem(
        id: 'ignored',
        conceptId: 'valid',
        prompt: 'Try again.',
        domain: ReviewDomain.expressive,
        dueAt: now,
      );
      final store = await createStore(
        clock: () => now,
        serialized: jsonEncode({
          'version': 2,
          'completed': [starterLesson.id],
          'activity': 'bad-map',
          'reviews': [
            valid.toJson(),
            {'conceptId': 'broken'},
          ],
          'evidence': [
            {'id': 42},
          ],
        }),
      );

      expect(store.storageError, isTrue);
      expect(store.completed, {starterLesson.id});
      expect(store.reviewQueue.single.conceptId, 'valid');
      expect(store.evidence, isEmpty);
      await store.setGoal(5);
      final reloaded = LearningStore(store.preferences, clock: () => now);
      addTearDown(reloaded.dispose);
      expect(reloaded.storageError, isFalse);
      expect(reloaded.reviewQueue.single.conceptId, 'valid');
    },
  );

  test('concurrent portfolio writes persist distinct self-reviews', () async {
    final now = DateTime.utc(2026, 9, 5, 12);
    final store = await createStore(clock: () => now);
    await Future.wait([
      store.addEvidence(
        activityId: 'scene',
        title: 'My scene',
        reflection: 'First attempt.',
      ),
      store.addEvidence(
        activityId: 'scene',
        title: 'My scene',
        reflection: 'Second attempt.',
      ),
    ]);
    final reloaded = LearningStore(store.preferences, clock: () => now);
    addTearDown(reloaded.dispose);

    expect(reloaded.evidence, hasLength(2));
    expect(reloaded.evidence.map((e) => e.id).toSet(), hasLength(2));
    expect(reloaded.evidence.first.reflection, 'Second attempt.');
    expect(reloaded.todayMinutes, 0);
    expect(reloaded.streak, 0);
  });

  test(
    'reset clears review queue and portfolio along with learning history',
    () async {
      final store = await createStore();
      await store.addReview(conceptId: 'hello', prompt: 'Say hello.');
      await store.addEvidence(
        activityId: 'hello',
        title: 'Hello',
        reflection: 'A note.',
      );
      await store.reset();
      final reloaded = LearningStore(store.preferences);
      addTearDown(reloaded.dispose);

      expect(reloaded.reviewQueue, isEmpty);
      expect(reloaded.evidence, isEmpty);
      expect(reloaded.completed, isEmpty);
    },
  );
}
