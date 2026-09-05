import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/features/practice/camera_stage.dart';

void main() {
  const channel = MethodChannel('camera_macos');
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <MethodCall>[];

  Future<void> mount(WidgetTester tester) => tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(width: 440, child: CameraStage()),
        ),
      ),
    ),
  );

  void cameraTest(String description, WidgetTesterCallback test) {
    testWidgets(
      description,
      test,
      variant: TargetPlatformVariant.only(TargetPlatform.macOS),
    );
  }

  setUp(() {
    calls.clear();
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      call,
    ) async {
      calls.add(call);
      return switch (call.method) {
        'listDevices' => {
          'devices': [
            {
              'deviceId': 'front',
              'localizedName': 'Front camera',
              'deviceType': 0,
            },
            {
              'deviceId': 'external',
              'localizedName': 'External camera',
              'deviceType': 0,
            },
          ],
        },
        'initialize' => {
          'textureId': 1,
          'size': {'width': 1280.0, 'height': 720.0},
          'devices': <Object>[],
        },
        'destroy' => true,
        _ => throw StateError('Unexpected camera operation: ${call.method}'),
      };
    });
  });

  tearDown(() {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  cameraTest(
    'camera starts only on request, disables audio, and releases on stop',
    (tester) async {
      await mount(tester);
      expect(calls, isEmpty);
      expect(find.text('Camera is off'), findsOneWidget);
      await tester.tap(find.text('Start camera'));
      await tester.pumpAndSettle();
      expect(find.text('LIVE'), findsOneWidget);
      final arguments =
          calls.singleWhere((call) => call.method == 'initialize').arguments
              as Map;
      expect(arguments['enableAudio'], false);
      expect(arguments['isVideoMirrored'], true);
      expect(find.byTooltip('Switch camera'), findsOneWidget);
      await tester.tap(find.byTooltip('Turn camera off'));
      await tester.pumpAndSettle();
      expect(calls.last.method, 'destroy');
      expect(find.text('Camera is off'), findsOneWidget);
      expect(
        calls.map((call) => call.method),
        isNot(contains('startRecording')),
      );
    },
  );

  cameraTest('denied Mac permission explains where to enable access', (
    tester,
  ) async {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => {
        'error': {
          'code': 'CAMERA_INITIALIZATION_ERROR',
          'message': 'Permission not granted',
        },
      },
    );
    await mount(tester);
    await tester.tap(find.text('Start camera'));
    await tester.pumpAndSettle();
    expect(find.textContaining('System Settings'), findsOneWidget);
    expect(find.text('Start camera'), findsOneWidget);
    expect(find.text('LIVE'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  cameraTest('empty camera list offers a no-camera practice route', (
    tester,
  ) async {
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (call) async => {'devices': <Object>[]},
    );
    await mount(tester);
    await tester.tap(find.text('Start camera'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No camera was found'), findsOneWidget);
    expect(find.text('Practice without camera'), findsOneWidget);
  });

  cameraTest('offline practice runs a countdown then an honest self-review', (
    tester,
  ) async {
    await mount(tester);
    await tester.ensureVisible(find.text('Practice without camera'));
    await tester.tap(find.text('Practice without camera'));
    await tester.pump();
    expect(find.text('GET READY'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('PRACTICE HELLO'), findsOneWidget);
    await tester.pump(const Duration(seconds: 12));
    expect(find.text('How did that feel?'), findsOneWidget);
    expect(find.textContaining('not an accuracy score'), findsOneWidget);
    final complete = find.widgetWithText(FilledButton, 'Complete');
    expect(tester.widget<FilledButton>(complete).onPressed, isNull);
    for (var i = 0; i < 3; i++) {
      final checkbox = find.byType(CheckboxListTile).at(i);
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pump();
    }
    await tester.ensureVisible(complete);
    await tester.tap(complete);
    await tester.pump();
    expect(find.text('Practice reflected. Keep going.'), findsOneWidget);
    expect(calls, isEmpty);
    expect(tester.takeException(), isNull);
  });

  cameraTest('backgrounding stops the native camera session', (tester) async {
    await mount(tester);
    await tester.tap(find.text('Start camera'));
    await tester.pumpAndSettle();
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    expect(calls.last.method, 'destroy');
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text('LIVE'), findsNothing);
  });
}
