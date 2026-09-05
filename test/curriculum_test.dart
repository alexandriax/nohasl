import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/data/curriculum.dart';
import 'package:nohasl/data/program_blueprints.dart';

// These are migration baselines for the original authored lesson purposes and
// content, not generated expectations from the current curriculum at test time.
const legacyLessons = <String, (String, LessonMode, int)>{
  "a-first-hello": ("A first hello", LessonMode.guided, 1583133013),
  "space-to-sign": ("Space to sign", LessonMode.camera, 1339404837),
  "a-little-kindness": ("A little kindness", LessonMode.recall, 681629233),
  "names-have-rhythm": ("Names have rhythm", LessonMode.guided, 752038368),
  "meet-someone-new": ("Meet someone new", LessonMode.conversation, 1891856738),
  "asking-again": ("The power of again", LessonMode.camera, 1121502161),
  "five-things-to-notice": (
    "Five things to notice",
    LessonMode.guided,
    877895629,
  ),
  "your-face-is-grammar": (
    "Your face is grammar",
    LessonMode.camera,
    245479473,
  ),
  "language-and-community": (
    "Language lives in community",
    LessonMode.story,
    1683800169,
  ),
  "my-circle": ("My circle", LessonMode.guided, 1160485595),
  "where-things-belong": ("Where things belong", LessonMode.camera, 819132437),
  "find-the-blue-bag": ("Find the blue bag", LessonMode.recall, 39806746),
  "numbers-in-context": ("Numbers in context", LessonMode.guided, 1488675491),
  "a-day-in-your-life": ("A day in your life", LessonMode.camera, 1163449240),
  "what-you-love": ("What you love", LessonMode.conversation, 1184213359),
  "your-usual-order": ("Your usual order", LessonMode.story, 1403635693),
  "a-seat-by-the-window": (
    "A seat by the window",
    LessonMode.camera,
    764821632,
  ),
  "see-you-next-time": (
    "See you next time",
    LessonMode.conversation,
    935626382,
  ),
  "an-invitation": ("An invitation", LessonMode.conversation, 570751811),
  "plans-can-change": ("Plans can change", LessonMode.story, 273157516),
  "remember-the-details": (
    "Remember the details",
    LessonMode.recall,
    729653226,
  ),
  "a-room-in-space": ("A room in space", LessonMode.guided, 384079911),
  "showing-movement": ("Showing movement", LessonMode.camera, 874546894),
  "this-one-or-that-one": (
    "This one or that one?",
    LessonMode.recall,
    2090291756,
  ),
  "a-helpful-request": (
    "A helpful request",
    LessonMode.conversation,
    806115050,
  ),
  "getting-there": ("Getting there", LessonMode.camera, 367713528),
  "solve-it-together": ("Solve it together", LessonMode.story, 1212887718),
  "set-the-scene": ("Set the scene", LessonMode.guided, 349227343),
  "then-something-happened": (
    "Then something happened",
    LessonMode.camera,
    1814977668,
  ),
  "an-ending-that-lands": ("An ending that lands", LessonMode.story, 83806224),
  "who-is-speaking": ("Who is speaking?", LessonMode.guided, 2029283970),
  "show-the-reaction": ("Show the reaction", LessonMode.camera, 330494206),
  "same-event-new-view": (
    "Same event, new view",
    LessonMode.recall,
    1349466599,
  ),
  "the-empty-table": ("The empty table", LessonMode.story, 1685405887),
  "a-useful-clue": ("A useful clue", LessonMode.conversation, 1836107458),
  "the-story-you-tell": ("The story you tell", LessonMode.camera, 1702922843),
  "a-place-in-the-circle": (
    "A place in the circle",
    LessonMode.guided,
    1867640665,
  ),
  "agree-and-add": ("Agree and add", LessonMode.conversation, 649985416),
  "disagree-with-care": ("Disagree with care", LessonMode.camera, 1824116703),
  "many-ways-to-belong": ("Many ways to belong", LessonMode.story, 1946106239),
  "variation-is-language": (
    "Variation is language",
    LessonMode.recall,
    1614331948,
  ),
  "learning-with-people": (
    "Learning with people",
    LessonMode.conversation,
    158066554,
  ),
  "a-shared-plan": ("A shared plan", LessonMode.story, 1094012798),
  "when-details-shift": ("When details shift", LessonMode.camera, 478395889),
  "a-conversation-that-matters": (
    "A conversation that matters",
    LessonMode.conversation,
    824259164,
  ),
  "make-it-understandable": (
    "Make it understandable",
    LessonMode.guided,
    645095140,
  ),
  "a-case-worth-making": ("A case worth making", LessonMode.camera, 1010455152),
  "what-if": ("What if?", LessonMode.conversation, 2063001451),
  "a-language-of-art": ("A language of art", LessonMode.story, 882537203),
  "change-the-register": ("Change the register", LessonMode.camera, 527815943),
  "tell-it-your-way": ("Tell it your way", LessonMode.recall, 8436871),
  "the-unexpected-follow-up": (
    "The unexpected follow-up",
    LessonMode.conversation,
    509160867,
  ),
  "a-portfolio-with-purpose": (
    "A portfolio with purpose",
    LessonMode.camera,
    697072,
  ),
  "keep-the-conversation-going": (
    "Keep the conversation going",
    LessonMode.guided,
    2105041355,
  ),
};

int contentFingerprint(Lesson lesson) {
  final parts = <String>[
    lesson.title,
    lesson.subtitle,
    lesson.mode.name,
    '${lesson.minutes}',
    '${lesson.xp}',
    for (final step in lesson.steps) ...[
      step.title,
      step.body,
      step.prompt,
      step.choices.join('^'),
      step.correctChoice?.toString() ?? '',
      step.signWord ?? '',
    ],
  ];
  var hash = 0;
  for (final code in parts.join('|').codeUnits) {
    hash = (hash * 31 + code) & 0x7fffffff;
  }
  return hash;
}

void main() {
  test(
    'program has six coherent bands and every unit has eight activity types',
    () {
      expect(courseLevels, hasLength(6));
      expect(programBands, hasLength(6));
      expect(allLessons, hasLength(576));
      expect(courseLevels.expand((level) => level.units), hasLength(72));
      final allIds = <String>[];
      for (final level in courseLevels) {
        allIds.add(level.id);
        expect(level.units, hasLength(12), reason: level.title);
        for (final unit in level.units) {
          allIds.add(unit.id);
          expect(unit.lessons, hasLength(8), reason: unit.title);
          expect(
            unit.lessons.map((lesson) => lesson.activityKind),
            unorderedEquals(programActivityKinds),
            reason: unit.title,
          );
          allIds.addAll(unit.lessons.map((lesson) => lesson.id));
        }
      }
      expect(allIds.toSet(), hasLength(allIds.length));
      expect(
        allLessons.map((lesson) => lesson.mode).toSet(),
        containsAll(LessonMode.values),
      );
    },
  );

  test(
    'all 54 legacy lessons preserve IDs, purposes, and instructional content',
    () {
      expect(legacyLessons, hasLength(54));
      final current = {for (final lesson in allLessons) lesson.id: lesson};
      expect(starterLesson.id, 'a-first-hello');
      for (final entry in legacyLessons.entries) {
        final lesson = current[entry.key];
        expect(lesson, isNotNull, reason: 'Missing migration ID ${entry.key}');
        expect(lesson!.title, entry.value.$1, reason: entry.key);
        expect(lesson.mode, entry.value.$2, reason: entry.key);
        expect(
          contentFingerprint(lesson),
          entry.value.$3,
          reason: 'Original content changed for ${entry.key}',
        );
      }
    },
  );

  test('unit prerequisites are valid, earlier, and acyclic', () {
    final seen = <String>{};
    for (final unit in courseLevels.expand((level) => level.units)) {
      expect(
        unit.prerequisiteIds.every(seen.contains),
        isTrue,
        reason: '${unit.id} refers to a missing or later prerequisite',
      );
      expect(
        unit.prerequisiteIds.toSet(),
        hasLength(unit.prerequisiteIds.length),
      );
      if (seen.isEmpty) {
        expect(unit.prerequisiteIds, isEmpty);
      } else {
        expect(unit.prerequisiteIds, isNotEmpty);
      }
      seen.add(unit.id);
    }
  });

  test(
    'every authored brief has differentiated tasks and honest approval metadata',
    () {
      final briefs = programBands.expand((band) => band.units).toList();
      expect(briefs.map((unit) => unit.scenario).toSet(), hasLength(72));
      expect(briefs.map((unit) => unit.conceptQuestion).toSet(), hasLength(72));
      for (final brief in briefs) {
        expect(brief.objectives.length, greaterThanOrEqualTo(2));
        expect(brief.vocabulary.length, greaterThanOrEqualTo(5));
        expect(brief.grammarFocus, isNotEmpty);
        expect(brief.cultureFocus, isNotEmpty);
        expect(brief.receptiveTask, isNotEmpty);
        expect(brief.expressiveTask, isNotEmpty);
        expect(brief.receptiveTask, isNot(brief.expressiveTask));
        expect(brief.partnerA, isNotEmpty);
        expect(brief.partnerB, isNot(brief.partnerA));
        expect(brief.transferTwist, isNotEmpty);
        expect(brief.rubric, hasLength(3));
        expect(brief.conceptAnswers.toSet(), hasLength(3));
        expect(brief.referenceUrls.length, greaterThanOrEqualTo(2));
        for (final reference in brief.referenceUrls) {
          final url = Uri.parse(reference);
          expect(url.scheme, 'https');
          expect(url.host, isNotEmpty);
        }
        expect(brief.educatorReviewStatus, contains('Pending'));
        expect(brief.mediaStatus, contains('not yet supplied'));
        expect(brief.assessmentStatus, contains('not a validated'));
      }
    },
  );

  test(
    'compiled activities retain meaningful goals and correct concept answer keys',
    () {
      final briefs = {
        for (final band in programBands)
          for (final brief in band.units) brief.id: brief,
      };
      final answerPositions = <int>{};
      for (final unit in courseLevels.expand((level) => level.units)) {
        final brief = briefs[unit.id]!;
        expect(unit.objectives, brief.objectives);
        expect(unit.vocabulary, brief.vocabulary);
        expect(unit.grammarFocus, brief.grammarFocus);
        expect(unit.cultureFocus, brief.cultureFocus);
        expect(unit.rubric, brief.rubric);
        expect(unit.referenceUrls, brief.referenceUrls);
        for (final lesson in unit.lessons) {
          expect(lesson.objectives, isNotEmpty);
          expect(lesson.conceptIds, contains(unit.id));
          expect(lesson.minutes, greaterThan(0));
          expect(lesson.xp, greaterThan(0));
          expect(lesson.steps.length, greaterThanOrEqualTo(3));
          if (!legacyLessons.containsKey(lesson.id)) {
            expect(lesson.requiresReferenceVideo, isTrue);
            expect(lesson.id, '${unit.id}--${lesson.activityKind}');
          }
          for (final step in lesson.steps) {
            expect(step.title, isNotEmpty);
            expect(step.body, isNotEmpty);
            expect(step.prompt, isNotEmpty);
            if (step.correctChoice case final answer?) {
              expect(answer, inInclusiveRange(0, step.choices.length - 1));
              expect(step.choices.toSet(), hasLength(step.choices.length));
              answerPositions.add(answer);
              if (!legacyLessons.containsKey(lesson.id)) {
                expect(step.choices[answer], brief.conceptAnswers.first);
              }
            }
          }
          if (lesson.activityKind == 'checkpoint') {
            expect(lesson.steps.last.choices, isNotEmpty);
            expect(
              lesson.steps.last.correctChoice,
              isNull,
              reason: 'Self-reflection must not pretend to grade proficiency',
            );
          }
        }
      }
      expect(answerPositions, containsAll([0, 1, 2]));
    },
  );

  test('the public program collections cannot be mutated by consumers', () {
    expect(() => courseLevels.clear(), throwsUnsupportedError);
    expect(() => courseLevels.first.units.clear(), throwsUnsupportedError);
    expect(
      () => courseLevels.first.units.first.lessons.clear(),
      throwsUnsupportedError,
    );
    expect(() => allLessons.clear(), throwsUnsupportedError);
    expect(() => programBands.clear(), throwsUnsupportedError);
    expect(
      () => programBands.first.units.first.objectives.clear(),
      throwsUnsupportedError,
    );
  });
}
