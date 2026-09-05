import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nohasl/data/curriculum.dart';
import 'package:nohasl/main.dart';
import 'package:nohasl/state/learning_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native learning, progress, library and camera-free practice', (
    tester,
  ) async {
    // Isolate test progress from the learner's real app data.
    SharedPreferences.setMockInitialValues({});
    final store = LearningStore(await SharedPreferences.getInstance());
    await tester.pumpWidget(NohaslApp(store: store));
    await tester.pumpAndSettle();
    expect(find.text('Small gestures.\nBig connections.'), findsOneWidget);
    await tester.tap(find.text('Start my journey'));
    await tester.pumpAndSettle();
    Future<void> tapText(String value) async {
      await tester.ensureVisible(find.text(value).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text(value).last);
      await tester.pumpAndSettle();
    }

    await tapText('Continue');
    await tapText(
      starterLesson.steps[1].choices[starterLesson.steps[1].correctChoice!],
    );
    await tapText('Check answer');
    await tapText('Continue');
    expect(find.text('Start camera'), findsOneWidget);
    await tapText('Complete reflection');
    expect(find.text('One step closer.'), findsOneWidget);
    expect(store.xp, starterLesson.xp);
    await tapText('Back to my journey');
    expect(find.text('Continue learning'), findsOneWidget);
    Future<void> navigate(String title) async {
      final menu = find.byTooltip('Open navigation');
      if (menu.evaluate().isNotEmpty) {
        await tester.tap(menu);
        await tester.pumpAndSettle();
      }
      await tapText(title);
    }

    await navigate('Sign library');
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Save Hello'));
    await tester.tap(find.byTooltip('Save Hello'));
    await tester.pumpAndSettle();
    expect(store.saved, contains('Hello'));
    await navigate('Practice studio');
    await tester.ensureVisible(find.byTooltip('Open free practice mirror'));
    await tester.tap(find.byTooltip('Open free practice mirror'));
    await tester.pumpAndSettle();
    expect(find.text('Start camera'), findsOneWidget);
    await navigate('Conversation room');
    final aiSwitch = find.byType(Switch);
    if (aiSwitch.evaluate().isNotEmpty) {
      await tester.ensureVisible(aiSwitch.first);
      await tester.tap(aiSwitch.first);
      await tester.pumpAndSettle();
    }
    await tapText('Begin conversation');
    expect(find.text('GUIDED PRACTICE CUE'), findsOneWidget);
    await tapText('Save a reflection');
    await tester.enterText(
      find.byType(TextField).last,
      'I practiced waiting for a visual reply.',
    );
    await tapText('Save reflection');
    expect(store.evidence, isNotEmpty);
    await navigate('Review & portfolio');
    expect(store.dueReviewCount, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
