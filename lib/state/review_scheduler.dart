/// A transparent retrieval heuristic, not FSRS or a validated ASL proficiency
/// model. Ratings describe the learner's own recall, never camera assessment.
enum ReviewDomain { expressive, receptive }

enum ReviewRating { again, hard, good, easy }

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.conceptId,
    required this.prompt,
    required this.domain,
    required this.dueAt,
    this.intervalDays = 0,
    this.repetitions = 0,
    this.lapses = 0,
    this.lastReviewedAt,
    this.lessonId,
  });

  final String id;
  final String conceptId;
  final String prompt;
  final ReviewDomain domain;
  final DateTime dueAt;
  final int intervalDays;
  final int repetitions;
  final int lapses;
  final DateTime? lastReviewedAt;
  final String? lessonId;

  static String keyFor(String conceptId, ReviewDomain domain) =>
      '${domain.name}:${Uri.encodeComponent(conceptId.trim().toLowerCase())}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'conceptId': conceptId,
    'prompt': prompt,
    'domain': domain.name,
    'dueAt': dueAt.toUtc().toIso8601String(),
    'intervalDays': intervalDays,
    'repetitions': repetitions,
    'lapses': lapses,
    'lastReviewedAt': lastReviewedAt?.toUtc().toIso8601String(),
    'lessonId': lessonId,
  };

  static ReviewItem? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final concept = raw['conceptId'];
    final prompt = raw['prompt'];
    final due = raw['dueAt'];
    final interval = raw['intervalDays'];
    final repetitions = raw['repetitions'];
    final lapses = raw['lapses'];
    if (concept is! String ||
        concept.trim().isEmpty ||
        prompt is! String ||
        prompt.trim().isEmpty ||
        due is! String ||
        interval is! int ||
        interval < 0 ||
        interval > 90 ||
        repetitions is! int ||
        repetitions < 0 ||
        lapses is! int ||
        lapses < 0) {
      return null;
    }
    final domain = ReviewDomain.values
        .where((d) => d.name == raw['domain'])
        .firstOrNull;
    final dueAt = DateTime.tryParse(due);
    if (domain == null || dueAt == null) return null;
    final last = raw['lastReviewedAt'];
    if (last != null && (last is! String || DateTime.tryParse(last) == null)) {
      return null;
    }
    return ReviewItem(
      id: keyFor(concept, domain),
      conceptId: concept,
      prompt: prompt,
      domain: domain,
      dueAt: dueAt.toUtc(),
      intervalDays: interval,
      repetitions: repetitions,
      lapses: lapses,
      lastReviewedAt: last is String ? DateTime.parse(last).toUtc() : null,
      lessonId: raw['lessonId'] is String ? raw['lessonId'] as String : null,
    );
  }
}

/// Schedule from the actual review time. Again retries after ten minutes;
/// successful ratings use capped whole-day intervals with no overdue bonus.
ReviewItem scheduleReview(ReviewItem item, ReviewRating rating, DateTime now) {
  final reviewedAt = now.toUtc();
  final previous = item.intervalDays;
  final proposed = switch (rating) {
    ReviewRating.again => 0,
    ReviewRating.hard => previous == 0 ? 1 : (previous * 1.2).ceil(),
    ReviewRating.good => previous == 0 ? 1 : previous * 2,
    ReviewRating.easy => previous == 0 ? 4 : (previous * 2.5).ceil(),
  };
  final days = proposed.clamp(0, 90).toInt();
  return ReviewItem(
    id: item.id,
    conceptId: item.conceptId,
    prompt: item.prompt,
    domain: item.domain,
    dueAt: reviewedAt.add(
      rating == ReviewRating.again
          ? const Duration(minutes: 10)
          : Duration(days: days),
    ),
    intervalDays: days,
    repetitions: rating == ReviewRating.again ? 0 : item.repetitions + 1,
    lapses: item.lapses + (rating == ReviewRating.again ? 1 : 0),
    lastReviewedAt: reviewedAt,
    lessonId: item.lessonId,
  );
}

/// A learner's written self-review and rubric snapshot. No video, recognition
/// result, teacher approval, or inferred language proficiency is stored here.
class PracticeEvidence {
  const PracticeEvidence({
    required this.id,
    required this.activityId,
    required this.title,
    required this.domain,
    required this.createdAt,
    required this.reflection,
    this.rubric = const [],
    this.rating,
    this.activeSeconds = 0,
  });

  final String id;
  final String activityId;
  final String title;
  final ReviewDomain domain;
  final DateTime createdAt;
  final String reflection;
  final List<String> rubric;
  final ReviewRating? rating;
  final int activeSeconds;
  String get source => 'Self-reported practice';

  Map<String, dynamic> toJson() => {
    'id': id,
    'activityId': activityId,
    'title': title,
    'domain': domain.name,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'reflection': reflection,
    'rubric': rubric,
    'rating': rating?.name,
    'activeSeconds': activeSeconds,
    'source': 'self-reported',
  };

  static PracticeEvidence? fromJson(Object? raw) {
    if (raw is! Map) return null;
    if (raw['id'] is! String ||
        (raw['id'] as String).isEmpty ||
        raw['activityId'] is! String ||
        raw['title'] is! String ||
        raw['reflection'] is! String ||
        raw['createdAt'] is! String) {
      return null;
    }
    final date = DateTime.tryParse(raw['createdAt'] as String);
    final domain = ReviewDomain.values
        .where((d) => d.name == raw['domain'])
        .firstOrNull;
    if (date == null || domain == null) return null;
    final rawRubric = raw['rubric'];
    if (rawRubric != null &&
        (rawRubric is! List || rawRubric.any((v) => v is! String))) {
      return null;
    }
    final rating = ReviewRating.values
        .where((r) => r.name == raw['rating'])
        .firstOrNull;
    if (raw['rating'] != null && rating == null) return null;
    final seconds = raw['activeSeconds'] ?? 0;
    if (seconds is! int || seconds < 0) return null;
    return PracticeEvidence(
      id: raw['id'] as String,
      activityId: raw['activityId'] as String,
      title: raw['title'] as String,
      domain: domain,
      createdAt: date.toUtc(),
      reflection: raw['reflection'] as String,
      rubric: List<String>.unmodifiable(
        (rawRubric as List? ?? []).cast<String>(),
      ),
      rating: rating,
      activeSeconds: seconds,
    );
  }
}
