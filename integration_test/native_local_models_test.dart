import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nohasl/features/conversation/apple_intelligence.dart';
import 'package:nohasl/features/local_models/local_model_backend_native.dart';
import 'package:path_provider/path_provider.dart';

const _fixturePath = String.fromEnvironment('NOHASL_NATIVE_MODEL_PATH');
const _fileName = 'qwen2.5-0.5b-instruct-q4_k_m.gguf';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'bundled native Qwen works on the actual app target',
    (tester) async {
      final appCache = await getApplicationCacheDirectory();
      await appCache.create(recursive: true);
      final directory = await appCache.createTemp('nohasl-native-integration-');
      final backend = NativeLocalModelBackend(
        cacheDirectory: () async => directory,
      );
      try {
        final id = backend.models.single.id;
        final fixture = File(_fixturePath);
        var copiedFixture = false;
        if (_fixturePath.isNotEmpty && await fixture.exists()) {
          final root = await Directory(
            '${directory.path}/nohasl_local_models',
          ).create(recursive: true);
          try {
            await fixture.copy('${root.path}/$_fileName');
            copiedFixture = true;
          } on FileSystemException {
            // Sandboxed applications can stat a host path they cannot read.
            // Use the normal verified app download without weakening sandboxing.
          }
        }
        if (!copiedFixture) {
          // Deliberately opt-in integration test: the published model is public,
          // and the production adapter verifies its exact pinned hash and size.
          var lastTenth = -1;
          await backend.download(id, (progress) {
            final tenth = ((progress.fraction ?? 0) * 10).floor();
            if (tenth != lastTenth) {
              lastTenth = tenth;
              // ignore: avoid_print
              print('Native model download ${tenth * 10}%');
            }
          });
          await expectLater(
            backend.respond(
              topic: 'A cafe',
              level: 'Beginner',
              message: 'Hello',
              history: const [],
            ),
            throwsA(
              isA<AiServiceException>().having(
                (error) => error.code,
                'code',
                'notLoaded',
              ),
            ),
          );
        }
        expect(await backend.downloadedModels(), {id});
        await backend.load(id);
        final first = await backend.respond(
          topic: 'A friendly cafe',
          level: 'Beginner',
          message: 'I would like a small coffee, please.',
          history: const [],
        );
        expect(first.reply, isNotEmpty);
        expect(first.followUpQuestion, isNotEmpty);
        expect(first.suggestedReply, isNotEmpty);
        expect(first.practiceGoal, isNotEmpty);
        // Synthetic test output only.
        // ignore: avoid_print
        print(
          '${Platform.operatingSystem} Qwen generated four fields: '
          '${first.reply} / ${first.followUpQuestion}',
        );
        final pending = backend.respond(
          topic: 'Travel plans',
          level: 'Intermediate',
          message:
              'Ask about where I want to travel and what I hope to discover.',
          history: const [],
        );
        final cancelled = expectLater(
          pending,
          throwsA(
            isA<AiServiceException>().having(
              (error) => error.code,
              'code',
              'cancelled',
            ),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await backend.reset();
        await cancelled;
        final afterReset = await backend.respond(
          topic: 'A library',
          level: 'Beginner',
          message: 'Where can I find picture books?',
          history: const [],
        );
        expect(afterReset.reply, isNotEmpty);
        await backend.remove(id);
        expect(await backend.downloadedModels(), isEmpty);
      } finally {
        await backend.dispose();
        await directory.delete(recursive: true);
      }
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
