import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/data/curriculum.dart';
import 'package:nohasl/state/learning_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<LearningStore> createStore({String? serialized}) async {
    SharedPreferences.setMockInitialValues({
      if (serialized != null) 'nohasl.v1': serialized,
    });
    final preferences = await SharedPreferences.getInstance();
    final store = LearningStore(preferences);
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
}
