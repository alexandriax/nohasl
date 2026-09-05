import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/features/conversation/apple_intelligence.dart';
import 'package:nohasl/features/local_models/local_model_backend_native.dart';

const _smokePath = String.fromEnvironment('NOHASL_NATIVE_MODEL_PATH');
const _fileName = 'qwen2.5-0.5b-instruct-q4_k_m.gguf';

Matcher _failure(String code) =>
    isA<AiServiceException>().having((error) => error.code, 'code', code);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  if (_smokePath.isNotEmpty) {
    // This opt-in suite intentionally checks the real, public model download.
    HttpOverrides.global = null;
  }

  test(
    'native cache ignores incomplete artifacts and removes only its files',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nohasl-cache-test-',
      );
      final backend = NativeLocalModelBackend(
        cacheDirectory: () async => directory,
      );
      try {
        expect((await backend.probe()).available, isTrue);
        expect(await backend.downloadedModels(), isEmpty);
        final root = Directory('${directory.path}/nohasl_local_models');
        final unrelated = File('${root.path}/keep.txt');
        await unrelated.writeAsString('unrelated file');
        await File('${root.path}/$_fileName.part').writeAsString('incomplete');
        await File('${root.path}/$_fileName').writeAsString('corrupt');
        expect(await backend.downloadedModels(), isEmpty);
        await expectLater(
          backend.load(backend.models.single.id),
          throwsA(_failure('notDownloaded')),
        );
        await backend.remove(backend.models.single.id);
        expect(await unrelated.readAsString(), 'unrelated file');
        expect(await File('${root.path}/$_fileName.part').exists(), isFalse);
        expect(await File('${root.path}/$_fileName').exists(), isFalse);
      } finally {
        await backend.dispose();
        await directory.delete(recursive: true);
      }
    },
  );

  test(
    'native download cancellation settles and cannot publish a model',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nohasl-download-test-',
      );
      final backend = NativeLocalModelBackend(
        cacheDirectory: () async => directory,
      );
      try {
        final started = Completer<void>();
        final download = backend.download(backend.models.single.id, (progress) {
          if ((progress.downloadedBytes ?? 0) > 0 && !started.isCompleted) {
            started.complete();
          }
        });
        final cancelled = expectLater(download, throwsA(_failure('cancelled')));
        await Future.any<void>([
          started.future,
          download,
        ]).timeout(const Duration(seconds: 60));
        await backend.cancelDownload();
        await cancelled;
        expect(await backend.downloadedModels(), isEmpty);
        expect(
          await File(
            '${directory.path}/nohasl_local_models/$_fileName.part',
          ).exists(),
          isFalse,
        );
      } finally {
        await backend.dispose();
        await directory.delete(recursive: true);
      }
    },
    skip: _smokePath.isEmpty,
    timeout: const Timeout(Duration(minutes: 2)),
  );

  test(
    'real Qwen runtime generates, cancels, resets, unloads and removes',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'nohasl-runtime-test-',
      );
      final backend = NativeLocalModelBackend(
        cacheDirectory: () async => directory,
      );
      try {
        final root = await Directory(
          '${directory.path}/nohasl_local_models',
        ).create(recursive: true);
        await File(_smokePath).copy('${root.path}/$_fileName');
        final id = backend.models.single.id;
        expect(await backend.downloadedModels(), {id});
        await backend.load(id);
        final stopwatch = Stopwatch()..start();
        final first = await backend.respond(
          topic: 'Ordering at a cafe',
          level: 'Beginner',
          message: 'I would like a small coffee, please.',
          history: const [],
        );
        expect(first.reply, isNotEmpty);
        expect(first.followUpQuestion, isNotEmpty);
        expect(first.suggestedReply, isNotEmpty);
        expect(first.practiceGoal, isNotEmpty);
        // Synthetic test content only; production runtime logging is disabled.
        // ignore: avoid_print
        print(
          'Native Qwen (${stopwatch.elapsedMilliseconds}ms): '
          '${first.reply} / ${first.followUpQuestion} / '
          '${first.suggestedReply} / ${first.practiceGoal}',
        );
        final pending = backend.respond(
          topic: 'Planning a weekend',
          level: 'Advanced',
          message: 'Suggest a thoughtful next step and ask about my plans.',
          history: const [],
        );
        final cancelled = expectLater(pending, throwsA(_failure('cancelled')));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await backend.reset();
        await cancelled;
        final afterReset = await backend.respond(
          topic: 'A museum visit',
          level: 'Beginner',
          message: 'Where is the entrance?',
          history: const [],
        );
        expect(afterReset.followUpQuestion, isNotEmpty);
        await backend.unload();
        await expectLater(
          backend.respond(
            topic: 'A museum visit',
            level: 'Beginner',
            message: 'Hello',
            history: const [],
          ),
          throwsA(_failure('notLoaded')),
        );
        expect(await backend.downloadedModels(), {id});
        await backend.remove(id);
        expect(await backend.downloadedModels(), isEmpty);
      } finally {
        await backend.dispose();
        await directory.delete(recursive: true);
      }
    },
    skip: _smokePath.isEmpty,
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
