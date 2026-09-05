import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/curriculum.dart';
import 'review_scheduler.dart';

export 'review_scheduler.dart';

class LearningStore extends ChangeNotifier {
  LearningStore(this.preferences, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
    _read();
  }
  final SharedPreferences preferences;
  final DateTime Function() _clock;
  final Map<String, ReviewItem> _reviews = {};
  final List<PracticeEvidence> _evidence = [];
  Future<void> _pendingSave = Future<void>.value();
  bool _disposed = false;
  int _evidenceSequence = 0;
  final Set<String> completed = {};
  final Set<String> saved = {};
  final Map<String, int> activity = {};
  int dailyGoal = 10;
  bool sound = false;
  bool storageError = false;
  int get xp => allLessons
      .where((l) => completed.contains(l.id))
      .fold(0, (v, l) => v + l.xp);
  String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  int get todayMinutes => activity[dateKey(_clock())] ?? 0;
  int get streak {
    final now = _clock();
    var day = DateTime(now.year, now.month, now.day);
    if (!activity.containsKey(dateKey(day))) {
      day = DateTime(day.year, day.month, day.day - 1);
    }
    var result = 0;
    while (activity.containsKey(dateKey(day))) {
      result++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return result;
  }

  Lesson get nextLesson => allLessons.firstWhere(
    (l) => !completed.contains(l.id),
    orElse: () => starterLesson,
  );

  /// Full queue sorted by due time. The visible due session is capped at ten.
  List<ReviewItem> get reviewQueue {
    final items = _reviews.values.toList()
      ..sort((a, b) {
        final order = a.dueAt.compareTo(b.dueAt);
        return order == 0 ? a.id.compareTo(b.id) : order;
      });
    return List.unmodifiable(items);
  }

  List<ReviewItem> get dueReviews => dueReviewsAt(_clock());
  int get dueReviewCount => _reviews.values
      .where((item) => !item.dueAt.isAfter(_clock().toUtc()))
      .length;
  List<PracticeEvidence> get evidence => List.unmodifiable(_evidence.reversed);

  List<ReviewItem> dueReviewsAt(DateTime now, {int limit = 10}) =>
      List.unmodifiable(
        reviewQueue
            .where((item) => !item.dueAt.isAfter(now.toUtc()))
            .take(limit.clamp(0, 50).toInt()),
      );

  void _read() {
    try {
      final data =
          jsonDecode(preferences.getString('nohasl.v1') ?? '{}')
              as Map<String, dynamic>;
      List<Object?> entries(String key) {
        final value = data[key];
        if (value == null) return const [];
        if (value is List) return value;
        storageError = true;
        return const [];
      }

      completed.addAll(
        entries(
          'completed',
        ).whereType<String>().where((id) => allLessons.any((l) => l.id == id)),
      );
      saved.addAll(entries('saved').whereType<String>());
      dailyGoal = [5, 10, 15, 20].contains(data['goal'])
          ? data['goal'] as int
          : 10;
      sound = data['sound'] == true;
      final rawActivity = data['activity'];
      if (rawActivity is Map) {
        rawActivity.forEach((k, v) {
          if (k is String && v is int && v > 0) activity[k] = v;
        });
      } else if (rawActivity != null) {
        storageError = true;
      }
      final rawReviews = data['reviews'];
      if (rawReviews is List) {
        for (final raw in rawReviews) {
          final item = ReviewItem.fromJson(raw);
          if (item == null) {
            storageError = true;
          } else {
            _reviews[item.id] = item;
          }
        }
      } else if (rawReviews != null) {
        storageError = true;
      }
      final rawEvidence = data['evidence'];
      if (rawEvidence is List) {
        for (final raw in rawEvidence) {
          final item = PracticeEvidence.fromJson(raw);
          if (item == null) {
            storageError = true;
          } else if (!_evidence.any((e) => e.id == item.id)) {
            _evidence.add(item);
          }
        }
      } else if (rawEvidence != null) {
        storageError = true;
      }
      // v1 had no review queue. Migrate completion into self-review prompts,
      // without inventing reviewed attempts or altering historical XP/time.
      if (data['version'] == null || data['version'] == 1) {
        for (final lesson in allLessons.where(
          (l) => completed.contains(l.id),
        )) {
          _enqueueLesson(lesson, _clock());
        }
      }
    } catch (_) {
      storageError = true;
    }
  }

  Future<void> _save() {
    _notify();
    // Serialize writes so an older asynchronous save cannot overwrite a newer
    // queue/evidence change. Keep the storage key to migrate v1 installations.
    _pendingSave = _pendingSave.then((_) async {
      try {
        final stored = await preferences.setString(
          'nohasl.v1',
          jsonEncode({
            'version': 2,
            'scheduler': 'nohasl-heuristic-v1',
            'completed': completed.toList(),
            'saved': saved.toList(),
            'goal': dailyGoal,
            'sound': sound,
            'activity': activity,
            'reviews': _reviews.values.map((r) => r.toJson()).toList(),
            'evidence': _evidence.map((e) => e.toJson()).toList(),
          }),
        );
        storageError = !stored;
      } catch (_) {
        storageError = true;
      }
      _notify();
    });
    return _pendingSave;
  }

  Future<void> complete(Lesson lesson, {required int activeSeconds}) async {
    final firstCompletion = completed.add(lesson.id);
    if (firstCompletion) _enqueueLesson(lesson, _clock());
    // Activity records time spent, never the advertised lesson duration.
    _recordSeconds(activeSeconds, _clock());
    await _save();
  }

  void _recordSeconds(int activeSeconds, DateTime at) {
    final minutes = (activeSeconds / 60).floor();
    if (minutes > 0) {
      final key = dateKey(at);
      activity[key] = (activity[key] ?? 0) + minutes;
    }
  }

  void _enqueueLesson(Lesson lesson, DateTime now) {
    final concepts = lesson.conceptIds.isEmpty
        ? [lesson.id]
        : lesson.conceptIds;
    final domain = lesson.activityKind == 'comprehension'
        ? ReviewDomain.receptive
        : ReviewDomain.expressive;
    for (final concept in concepts.toSet()) {
      _insertReview(
        conceptId: concept,
        prompt: domain == ReviewDomain.receptive
            ? 'Recall the main meaning and details from “${lesson.title}” without looking. '
                  'Revisit the lesson and any trusted signer reference, then reflect on what you understood.'
            : 'Recall the main idea from “${lesson.title}” without looking. '
                  'Rehearse it in a new situation, then revisit the lesson and reflect on what you need to review.',
        domain: domain,
        lessonId: lesson.id,
        dueAt: now,
      );
    }
  }

  void _insertReview({
    required String conceptId,
    required String prompt,
    required ReviewDomain domain,
    String? lessonId,
    required DateTime dueAt,
  }) {
    if (conceptId.trim().isEmpty || prompt.trim().isEmpty) return;
    final id = ReviewItem.keyFor(conceptId, domain);
    _reviews.putIfAbsent(
      id,
      () => ReviewItem(
        id: id,
        conceptId: conceptId.trim(),
        prompt: prompt.trim(),
        domain: domain,
        dueAt: dueAt.toUtc(),
        lessonId: lessonId,
      ),
    );
  }

  Future<void> addReview({
    required String conceptId,
    required String prompt,
    ReviewDomain domain = ReviewDomain.expressive,
    String? lessonId,
    DateTime? dueAt,
  }) async {
    _insertReview(
      conceptId: conceptId,
      prompt: prompt,
      domain: domain,
      lessonId: lessonId,
      dueAt: dueAt ?? _clock(),
    );
    await _save();
  }

  Future<void> recordReview(
    String itemId,
    ReviewRating rating, {
    String reflection = '',
    List<String> rubric = const [],
    int activeSeconds = 0,
    DateTime? at,
  }) async {
    final item = _reviews[itemId];
    if (item == null) return;
    final now = at ?? _clock();
    _reviews[itemId] = scheduleReview(item, rating, now);
    _appendEvidence(
      activityId: itemId,
      title: 'Review: ${item.conceptId}',
      reflection: reflection,
      rubric: rubric,
      domain: item.domain,
      rating: rating,
      activeSeconds: activeSeconds,
      at: now,
    );
    _recordSeconds(activeSeconds, now);
    await _save();
  }

  Future<void> addEvidence({
    required String activityId,
    required String title,
    required String reflection,
    List<String> rubric = const [],
    ReviewDomain domain = ReviewDomain.expressive,
    int activeSeconds = 0,
  }) async {
    final now = _clock();
    _appendEvidence(
      activityId: activityId,
      title: title,
      reflection: reflection,
      rubric: rubric,
      domain: domain,
      activeSeconds: activeSeconds,
      at: now,
    );
    _recordSeconds(activeSeconds, now);
    await _save();
  }

  void _appendEvidence({
    required String activityId,
    required String title,
    required String reflection,
    required List<String> rubric,
    required ReviewDomain domain,
    ReviewRating? rating,
    required int activeSeconds,
    required DateTime at,
  }) {
    if (activityId.trim().isEmpty || title.trim().isEmpty) return;
    final instant = at.toUtc();
    var id = '${instant.microsecondsSinceEpoch}-${_evidenceSequence++}';
    while (_evidence.any((e) => e.id == id)) {
      id = '${instant.microsecondsSinceEpoch}-${_evidenceSequence++}';
    }
    _evidence.add(
      PracticeEvidence(
        id: id,
        activityId: activityId.trim(),
        title: title.trim(),
        domain: domain,
        createdAt: instant,
        reflection: reflection.trim(),
        rubric: List.unmodifiable(rubric),
        rating: rating,
        activeSeconds: activeSeconds < 0 ? 0 : activeSeconds,
      ),
    );
  }

  Future<void> toggleSaved(String word) async {
    saved.contains(word) ? saved.remove(word) : saved.add(word);
    await _save();
  }

  Future<void> setGoal(int value) async {
    if (![5, 10, 15, 20].contains(value)) return;
    dailyGoal = value;
    await _save();
  }

  Future<void> setSound(bool value) async {
    sound = value;
    await _save();
  }

  Future<void> reset() async {
    completed.clear();
    saved.clear();
    activity.clear();
    _reviews.clear();
    _evidence.clear();
    await _save();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
