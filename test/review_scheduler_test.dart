import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/data/practice_activities.dart';
import 'package:nohasl/state/review_scheduler.dart';

void main() {
  final now = DateTime.utc(2026, 9, 5, 12);
  ReviewItem fresh({int interval = 0, int repetitions = 0, int lapses = 0}) =>
      ReviewItem(
        id: ReviewItem.keyFor('greeting', ReviewDomain.expressive),
        conceptId: 'greeting',
        prompt: 'Rehearse a greeting.',
        domain: ReviewDomain.expressive,
        dueAt: now,
        intervalDays: interval,
        repetitions: repetitions,
        lapses: lapses,
      );

  test('new successful reviews use clear first intervals', () {
    expect(
      scheduleReview(fresh(), ReviewRating.hard, now).dueAt,
      now.add(const Duration(days: 1)),
    );
    expect(
      scheduleReview(fresh(), ReviewRating.good, now).dueAt,
      now.add(const Duration(days: 1)),
    );
    expect(
      scheduleReview(fresh(), ReviewRating.easy, now).dueAt,
      now.add(const Duration(days: 4)),
    );
  });

  test('again resets repetitions and retries after ten minutes', () {
    final original = fresh(interval: 12, repetitions: 4, lapses: 2);
    final reviewed = scheduleReview(original, ReviewRating.again, now);

    expect(reviewed.dueAt, now.add(const Duration(minutes: 10)));
    expect(reviewed.intervalDays, 0);
    expect(reviewed.repetitions, 0);
    expect(reviewed.lapses, 3);
    expect(original.intervalDays, 12);
    expect(original.repetitions, 4);
  });

  test('rating changes the next interval without awarding overdue bonuses', () {
    final original = fresh(interval: 10, repetitions: 3);
    final late = now.add(const Duration(days: 25));
    final hard = scheduleReview(original, ReviewRating.hard, late);
    final good = scheduleReview(original, ReviewRating.good, late);
    final easy = scheduleReview(original, ReviewRating.easy, late);

    expect(hard.intervalDays, 12);
    expect(good.intervalDays, 20);
    expect(easy.intervalDays, 25);
    expect(good.dueAt, late.add(const Duration(days: 20)));
    expect(good.repetitions, 4);
    expect(good.lastReviewedAt, late);
  });

  test('successful intervals cap at ninety days', () {
    for (final rating in [
      ReviewRating.hard,
      ReviewRating.good,
      ReviewRating.easy,
    ]) {
      final result = scheduleReview(fresh(interval: 90), rating, now);
      expect(result.intervalDays, 90);
      expect(result.dueAt, now.add(const Duration(days: 90)));
    }
  });

  test('serialized dates represent instants across UTC offsets', () {
    final json = fresh().toJson()
      ..['dueAt'] = '2026-09-05T08:00:00-04:00'
      ..['lastReviewedAt'] = '2026-09-04T08:00:00-04:00';
    final restored = ReviewItem.fromJson(json)!;

    expect(restored.dueAt, now);
    expect(restored.lastReviewedAt, now.subtract(const Duration(days: 1)));
    expect(ReviewItem.fromJson(restored.toJson())!.dueAt, now);
  });

  test('invalid queue records are rejected without accepting fake domains', () {
    expect(
      ReviewItem.fromJson(fresh().toJson()..['domain'] = 'fluent'),
      isNull,
    );
    expect(ReviewItem.fromJson(fresh().toJson()..['dueAt'] = 'never'), isNull);
    expect(ReviewItem.fromJson(fresh().toJson()..['lapses'] = -1), isNull);
    expect(
      ReviewItem.fromJson(fresh().toJson()..['intervalDays'] = 1000),
      isNull,
    );
  });

  test('review identity normalizes concept labels but separates domains', () {
    expect(
      ReviewItem.keyFor(' Hello ', ReviewDomain.expressive),
      ReviewItem.keyFor('hello', ReviewDomain.expressive),
    );
    expect(
      ReviewItem.keyFor('hello', ReviewDomain.expressive),
      isNot(ReviewItem.keyFor('hello', ReviewDomain.receptive)),
    );
  });

  test(
    'practice catalog provides complete playable activities across levels',
    () {
      expect(practiceActivities.length, greaterThanOrEqualTo(24));
      expect(
        practiceActivities.map((a) => a.id).toSet().length,
        practiceActivities.length,
      );
      expect(practiceActivities.map((a) => a.minimumLevel).toSet(), {
        1,
        2,
        3,
        4,
        5,
        6,
      });
      expect(
        practiceActivities.map((a) => a.kind).toSet(),
        containsAll([
          'spatial_scene',
          'number_message',
          'fingerspelling',
          'nonmanual_reflection',
          'memory',
          'narrative_retell',
          'information_gap',
        ]),
      );
      for (final activity in practiceActivities) {
        expect(activity.objectives, isNotEmpty, reason: activity.id);
        expect(
          activity.instructions.length,
          greaterThanOrEqualTo(3),
          reason: activity.id,
        );
        expect(activity.cameraTask, isNotEmpty, reason: activity.id);
        expect(
          activity.rubric.length,
          greaterThanOrEqualTo(3),
          reason: activity.id,
        );
        expect(activity.conceptIds, isNotEmpty, reason: activity.id);
        if (activity.options.isNotEmpty) {
          expect(activity.correctOption, isNotNull, reason: activity.id);
          expect(
            activity.correctOption,
            inInclusiveRange(0, activity.options.length - 1),
            reason: activity.id,
          );
          expect(activity.explanation, isNotEmpty, reason: activity.id);
        } else {
          expect(activity.correctOption, isNull, reason: activity.id);
        }
      }
    },
  );
}
