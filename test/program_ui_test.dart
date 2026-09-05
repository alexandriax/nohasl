import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nohasl/state/learning_store.dart';
import 'package:nohasl/data/practice_activities.dart';
import 'package:nohasl/features/conversation/apple_intelligence.dart';
import 'package:nohasl/ui/conversation_page.dart';
import 'package:nohasl/ui/practice_lab.dart';
import 'package:nohasl/ui/review_hub.dart';

class TestConversationService extends AppleIntelligenceService {
  TestConversationService({this.available = false, this.pending});
  bool available;
  final Completer<ConversationTurn>? pending;
  List<ConversationMessage>? receivedHistory;
  String? receivedTopic;
  int resets = 0;
  @override
  Future<AiAvailability> availability() async => AiAvailability(
    status: available ? AiStatus.available : AiStatus.unsupportedPlatform,
    reason: available
        ? 'Available on this test device.'
        : 'Guided rehearsal is available.',
  );
  @override
  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) async {
    receivedTopic = topic;
    receivedHistory = history;
    return pending?.future ??
        const ConversationTurn(
          reply: 'The café has a quiet table by the window.',
          suggestedReply: 'That table would work for me.',
          practiceGoal: 'Negotiate a place to sit using known signs.',
          followUpQuestion: 'Would you prefer the window or the garden?',
        );
  }

  @override
  Future<void> reset() async {
    resets++;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'Manrope',
    )..addFont(rootBundle.load('assets/fonts/Manrope.ttf'))).load();
  });
  Future<LearningStore> createStore() async {
    SharedPreferences.setMockInitialValues({});
    return LearningStore(await SharedPreferences.getInstance());
  }

  Future<void> mount(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            primary: false,
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  testWidgets('new program surfaces render at phone and desktop widths', (
    tester,
  ) async {
    final store = await createStore();
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final size in [
      const Size(1440, 1000),
      const Size(390, 844),
      const Size(320, 740),
    ]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      for (final page in [
        PracticeLab(store: store),
        ReviewHub(store: store),
        ConversationPage(store: store, service: TestConversationService()),
      ]) {
        await mount(tester, page);
        expect(
          tester.takeException(),
          isNull,
          reason: '${page.runtimeType} $size',
        );
      }
    }
  });
  testWidgets(
    'guided conversation, custom topics and reset remain usable without Apple models',
    (tester) async {
      final store = await createStore();
      await mount(
        tester,
        ConversationPage(store: store, service: TestConversationService()),
      );
      await tapText(tester, 'Begin conversation');
      expect(find.text('GUIDED PRACTICE CUE'), findsOneWidget);
      await tapText(tester, 'Topic & practice stage');
      await tester.enterText(
        find.byType(TextField).first,
        'Gardening in a small apartment',
      );
      await tapText(tester, 'Set topic');
      expect(find.text('GUIDED PRACTICE CUE'), findsNothing);
      expect(find.text('Gardening in a small apartment'), findsNWidgets(2));
      await tapText(tester, 'Begin conversation');
      expect(
        find.textContaining('What would you like to explore about Gardening'),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'on-device conversation receives selected topic and returns structured coaching',
    (tester) async {
      final store = await createStore();
      final service = TestConversationService(available: true);
      await mount(tester, ConversationPage(store: store, service: service));
      await tapText(tester, 'At the café');
      await tapText(tester, 'Begin conversation');
      expect(service.receivedTopic, 'At the café');
      expect(service.receivedHistory, isEmpty);
      expect(find.textContaining('The café has a quiet table'), findsOneWidget);
      expect(find.text('ON-DEVICE CONVERSATION COACH'), findsOneWidget);
    },
  );
  testWidgets('availability change preserves generated message provenance', (
    tester,
  ) async {
    final store = await createStore();
    final service = TestConversationService(available: true);
    await mount(tester, ConversationPage(store: store, service: service));
    await tapText(tester, 'Begin conversation');
    service.available = false;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('ON-DEVICE CONVERSATION COACH'), findsOneWidget);
    expect(find.text('GUIDED PRACTICE CUE'), findsNothing);
    await tapText(tester, 'Start a guided conversation');
    expect(find.text('ON-DEVICE CONVERSATION COACH'), findsNothing);
    await tapText(tester, 'Begin conversation');
    expect(find.text('GUIDED PRACTICE CUE'), findsOneWidget);
  });
  testWidgets(
    'reflection saves only the learner reflection and generic activity metadata',
    (tester) async {
      final store = await createStore();
      await mount(
        tester,
        ConversationPage(
          store: store,
          service: TestConversationService(),
          initialTopic: 'A personal topic',
        ),
      );
      await tapText(tester, 'Begin conversation');
      await tapText(tester, 'Save a reflection');
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        'I practiced asking for clarification.',
      );
      await tapText(tester, 'Save reflection');
      expect(store.evidence, hasLength(1));
      expect(store.evidence.single.activityId, 'conversation');
      expect(store.evidence.single.title, 'Conversation reflection');
      expect(store.evidence.single.rubric, isEmpty);
      expect(
        store.evidence.single.reflection,
        'I practiced asking for clarification.',
      );
    },
  );
  testWidgets('late model response after leaving conversation is discarded', (
    tester,
  ) async {
    final store = await createStore();
    final result = Completer<ConversationTurn>();
    final service = TestConversationService(available: true, pending: result);
    await mount(tester, ConversationPage(store: store, service: service));
    await tester.ensureVisible(find.text('Begin conversation'));
    await tester.tap(find.text('Begin conversation'));
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: Text('Different page')));
    result.complete(
      const ConversationTurn(
        reply: 'Late',
        suggestedReply: 'Late',
        practiceGoal: 'Late',
        followUpQuestion: 'Late',
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Late'), findsNothing);
    expect(service.resets, greaterThan(0));
  });
  testWidgets(
    'activity validates a concept and saves deliberate reflection with review items',
    (tester) async {
      final store = await createStore();
      final activity = practiceActivities.first;
      await tester.pumpWidget(
        MaterialApp(
          home: ActivitySession(activity: activity, store: store),
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Start activity');
      await tapText(tester, activity.options[activity.correctOption!]);
      await tapText(tester, 'Check the idea');
      await tapText(tester, 'Reflect on the attempt');
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(
        find.byType(TextField),
        'I left a clear pause and want to practice repair next.',
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Save practice & schedule review');
      expect(store.evidence.single.reflection, contains('clear pause'));
      expect(store.reviewQueue.length, activity.conceptIds.length);
      expect(find.text('Carry this practice forward.'), findsOneWidget);
    },
  );
  testWidgets(
    'recall rating moves item out of the due queue and stores self-report',
    (tester) async {
      final store = await createStore();
      await store.addReview(
        conceptId: 'clarification',
        prompt: 'Ask for a repeat using a strategy you know.',
      );
      final item = store.dueReviews.single;
      await tester.pumpWidget(
        MaterialApp(
          home: RecallSession(store: store, item: item),
        ),
      );
      await tester.pumpAndSettle();
      await tapText(tester, 'Reveal reflection cues');
      await tapText(tester, 'Good');
      expect(store.dueReviewCount, 0);
      expect(store.evidence.single.source, 'Self-reported practice');
      expect(find.text('We’ll come back to this.'), findsOneWidget);
    },
  );
}
