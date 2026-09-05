import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nohasl/main.dart';
import 'package:nohasl/state/learning_store.dart';
import 'package:nohasl/data/curriculum.dart';
import 'package:nohasl/ui/learning_pages.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Manrope')
      ..addFont(rootBundle.load('assets/fonts/Manrope.ttf'));
    await loader.load();
  });
  Future<LearningStore> store() async {
    SharedPreferences.setMockInitialValues({});
    return LearningStore(await SharedPreferences.getInstance());
  }

  testWidgets(
    'dashboard and all destinations render at desktop and phone sizes',
    (tester) async {
      final data = await store();
      for (final size in [
        const Size(1440, 1000),
        const Size(1024, 768),
        const Size(390, 844),
        const Size(320, 740),
      ]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(NohaslApp(key: UniqueKey(), store: data));
        await tester.pumpAndSettle();
        expect(find.text('Small gestures.\nBig connections.'), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'Dashboard at $size');
        for (final page in [
          LearningPath(store: data, onLesson: (_) {}),
          const PracticePage(),
          StoriesPage(store: data, onLesson: (_) {}),
          LibraryPage(store: data),
          ProgressPage(store: data, onNavigate: (_) {}),
        ]) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: page,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${page.runtimeType} at $size',
          );
        }
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    },
  );
  testWidgets('lesson validates wrong answer, completes and persists XP', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1100, 1800);
    tester.view.devicePixelRatio = 1;
    final data = await store();
    await tester.pumpWidget(
      MaterialApp(
        home: LessonPlayer(lesson: starterLesson, store: data),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(starterLesson.steps[1].choices[0]));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Take another look'), findsOneWidget);
    expect(data.completed, isEmpty);
    await tester.tap(
      find.text(
        starterLesson.steps[1].choices[starterLesson.steps[1].correctChoice!],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Complete reflection'));
    await tester.tap(find.text('Complete reflection'));
    await tester.pumpAndSettle();
    expect(find.text('One step closer.'), findsOneWidget);
    expect(data.xp, starterLesson.xp);
    expect(data.completed, contains(starterLesson.id));
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  testWidgets('library search and bookmark are interactive', (tester) async {
    final data = await store();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ListenableBuilder(
              listenable: data,
              builder: (context, _) => LibraryPage(store: data),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.pumpAndSettle();
    expect(find.text('Hello'), findsNWidgets(2));
    expect(find.text('Coffee'), findsNothing);
    await tester.ensureVisible(find.byTooltip('Save Hello'));
    await tester.tap(find.byTooltip('Save Hello'));
    await tester.pumpAndSettle();
    expect(data.saved, contains('Hello'));
  });
  test('curriculum ids and answer keys are consistent', () {
    expect(courseLevels.length, 6);
    expect(allLessons.length, 576);
    expect(allLessons.map((l) => l.id).toSet().length, allLessons.length);
    for (final lesson in allLessons) {
      expect(lesson.steps, isNotEmpty);
      for (final step in lesson.steps) {
        if (step.correctChoice != null) {
          expect(
            step.correctChoice!,
            inInclusiveRange(0, step.choices.length - 1),
          );
        }
      }
    }
  });
}
