import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nohasl/features/conversation/apple_intelligence.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('nohasl/apple_intelligence');

  testWidgets('native Apple Intelligence availability, generation, and reset', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Verifying on-device conversation support')),
        ),
      ),
    );
    // Use the raw channel first so an absent registration cannot masquerade
    // as a normal unsupported-device fallback in this native integration test.
    final native = await channel.invokeMapMethod<Object?, Object?>(
      'availability',
    );
    expect(native, isNotNull);
    expect(
      AiStatus.values.map((status) => status.name),
      contains(native!['status']),
    );
    final service = AppleIntelligenceService();
    final availability = await service.availability();
    debugPrint('Native Apple Intelligence status: ${availability.status.name}');
    expect(availability.status.name, native['status']);
    await service.reset();
    if (availability.isAvailable) {
      final turn = await service.respond(
        topic: 'At a cafe',
        level: 'Beginner',
        message: 'Hello, I would like a tea please.',
        history: const [],
      );
      expect(turn.reply, isNotEmpty);
      expect(turn.suggestedReply, isNotEmpty);
      expect(turn.followUpQuestion, isNotEmpty);
      expect(turn.practiceGoal, isNotEmpty);
      debugPrint(
        'Native model generated all four validated conversation fields.',
      );

      final pending = channel.invokeMapMethod<Object?, Object?>('respond', {
        'topic': 'Meeting a neighbor',
        'level': 'Beginner',
        'message': 'Hello, I just moved here.',
        'history': <Object>[],
      });
      final canceled = expectLater(
        pending,
        throwsA(
          isA<PlatformException>().having(
            (error) => error.code,
            'code',
            'cancelled',
          ),
        ),
      );
      await channel.invokeMethod<void>('reset');
      await canceled;
    } else {
      await expectLater(
        service.respond(
          topic: 'At a cafe',
          level: 'Beginner',
          message: 'Hello!',
          history: const [],
        ),
        throwsA(
          isA<AiServiceException>().having(
            (error) => error.code,
            'code',
            availability.status.name,
          ),
        ),
      );
    }
    await service.reset();
    expect(tester.takeException(), isNull);
  });
}
