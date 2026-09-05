import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nohasl/features/conversation/apple_intelligence.dart';
import 'package:nohasl/features/local_models/local_model_backend.dart';
import 'package:nohasl/features/local_models/local_model_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _small = LocalModelSpec(
  id: 'small',
  name: 'Small',
  description: 'Small test model',
  downloadBytes: 100,
  memoryGiB: 1,
  license: 'Apache 2.0',
  licenseUrl: 'https://example.org/license',
  sourceUrl: 'https://example.org/model',
  revision: 'pinned-release',
);
const _large = LocalModelSpec(
  id: 'large',
  name: 'Large',
  description: 'Large test model',
  downloadBytes: 200,
  memoryGiB: 2,
  license: 'Apache 2.0',
  licenseUrl: 'https://example.org/license',
  sourceUrl: 'https://example.org/model',
  revision: 'pinned-release',
);
const _turn = ConversationTurn(
  reply: 'Hello! I would like some tea.',
  suggestedReply: 'What kind would you like?',
  practiceGoal: 'Notice your turn-taking.',
  followUpQuestion: 'Do you have green tea?',
);

class FakeLocalModelBackend extends LocalModelBackend {
  @override
  List<LocalModelSpec> get models => const [_small, _large];
  LocalModelSupport support = const LocalModelSupport(
    available: true,
    reason: 'Ready',
    availableStorageBytes: 1000,
  );
  final inventory = <String>{};
  final trace = <String>[];
  String? loaded;
  Completer<void>? probeGate;
  Completer<void>? downloadGate;
  Completer<void>? loadGate;
  Completer<void>? resetGate;
  Completer<void>? cancelGate;
  Completer<ConversationTurn>? responseGate;
  void Function(ModelDownloadProgress)? reportProgress;
  AiServiceException? downloadError;
  AiServiceException? loadError;
  AiServiceException? resetError;
  AiServiceException? inventoryError;
  AiServiceException? removeError;
  bool downloadCancelled = false;
  bool cancelSettlesDownload = true;
  bool retainRemovedFile = false;

  @override
  Future<LocalModelSupport> probe() async {
    trace.add('probe');
    await probeGate?.future;
    return support;
  }

  @override
  Future<Set<String>> downloadedModels() async {
    trace.add('inventory');
    if (inventoryError != null) throw inventoryError!;
    return Set.of(inventory);
  }

  @override
  Future<void> download(
    String modelId,
    void Function(ModelDownloadProgress) onProgress,
  ) async {
    trace.add('download:$modelId');
    reportProgress = onProgress;
    downloadCancelled = false;
    onProgress(
      const ModelDownloadProgress(
        message: 'Downloading',
        fraction: .25,
        downloadedBytes: 25,
        totalBytes: 100,
      ),
    );
    await downloadGate?.future;
    if (downloadCancelled) {
      throw const AiServiceException('cancelled', 'Cancelled.');
    }
    if (downloadError != null) throw downloadError!;
    inventory.add(modelId);
  }

  @override
  Future<void> cancelDownload() async {
    trace.add('cancelDownload');
    downloadCancelled = true;
    await cancelGate?.future;
    if (cancelSettlesDownload && downloadGate?.isCompleted == false) {
      downloadGate!.complete();
    }
  }

  @override
  Future<void> load(String modelId) async {
    trace.add('load:$modelId');
    await loadGate?.future;
    if (loadError != null) throw loadError!;
    loaded = modelId;
  }

  @override
  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) async {
    trace.add('respond');
    return responseGate == null ? _turn : await responseGate!.future;
  }

  @override
  Future<void> reset() async {
    trace.add('reset');
    await resetGate?.future;
    if (resetError != null) throw resetError!;
  }

  @override
  Future<void> unload() async {
    trace.add('unload');
    loaded = null;
  }

  @override
  Future<void> remove(String modelId) async {
    trace.add('remove:$modelId');
    if (removeError != null) throw removeError!;
    if (!retainRemovedFile) inventory.remove(modelId);
  }

  @override
  Future<void> dispose() async => trace.add('dispose');
}

Matcher failsWith(String code) => throwsA(
  isA<AiServiceException>().having((error) => error.code, 'code', code),
);

Future<void> flush() => Future<void>.delayed(Duration.zero);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeLocalModelBackend backend;
  late LocalModelManager manager;

  Future<ConversationTurn> respond({String message = 'Hello!'}) =>
      manager.respond(
        topic: 'At the cafe',
        level: 'Beginner',
        message: message,
        history: const [],
      );

  Future<void> ready() async {
    backend.inventory.add('small');
    await manager.initialize();
    await manager.load('small');
    backend.trace.clear();
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    backend = FakeLocalModelBackend();
    manager = LocalModelManager(backend);
  });

  tearDown(() async {
    manager.dispose();
    await manager.shutdownComplete;
  });

  test(
    'initialization discovers real cache without loading or downloading',
    () async {
      backend.inventory.addAll(['small', 'unknown-old-release']);
      SharedPreferences.setMockInitialValues({
        LocalModelManager.preferencesKey: jsonEncode({
          'version': 1,
          'preferredProvider': 'local:small',
        }),
      });
      final first = manager.initialize();
      final second = manager.initialize();
      await Future.wait([first, second]);

      expect(manager.downloadedIds, {'small'});
      expect(manager.preferredProvider, 'local:small');
      expect(manager.loadedModelId, isNull);
      expect(manager.phase, LocalModelPhase.idle);
      expect(backend.trace, ['probe', 'inventory']);
      expect(() => manager.downloadedIds.add('large'), throwsUnsupportedError);
      expect(() => manager.models.clear(), throwsUnsupportedError);
    },
  );

  test('corrupt or unsupported preferences cannot select a model', () async {
    for (final raw in [
      'not json',
      '{"version":1,"preferredProvider":4}',
      '{"version":2,"preferredProvider":"local:small"}',
      '{"version":1,"preferredProvider":"local:unlisted"}',
    ]) {
      SharedPreferences.setMockInitialValues({
        LocalModelManager.preferencesKey: raw,
      });
      final instance = LocalModelManager(FakeLocalModelBackend());
      await instance.initialize();
      expect(instance.preferredProvider, isNull);
      instance.dispose();
      await instance.shutdownComplete;
    }
  });

  test(
    'download caches only; loading and provider selection stay explicit',
    () async {
      backend.downloadGate = Completer<void>();
      await manager.initialize();
      final download = manager.download('small');
      await flush();
      expect(manager.phase, LocalModelPhase.downloading);
      expect(manager.isBusy, isTrue);
      expect(manager.workingModelId, 'small');
      expect(manager.progress?.fraction, .25);
      expect(manager.downloadedIds, isEmpty);

      backend.downloadGate!.complete();
      await download;
      expect(manager.downloadedIds, {'small'});
      expect(manager.loadedModelId, isNull);
      expect(manager.preferredProvider, isNull);
      expect(manager.phase, LocalModelPhase.idle);
      expect(manager.progress, isNull);
      expect(
        backend.trace.where((entry) => entry.startsWith('load:')),
        isEmpty,
      );
    },
  );

  test('known free storage reserves temporary installation space', () async {
    backend.support = const LocalModelSupport(
      available: true,
      reason: 'Ready',
      availableStorageBytes: 199,
    );
    await expectLater(
      manager.download('small'),
      failsWith('insufficientStorage'),
    );
    expect(backend.trace, isNot(contains('download:small')));
    expect(manager.errorCode, 'insufficientStorage');
    expect(manager.phase, LocalModelPhase.error);

    backend.support = const LocalModelSupport(
      available: true,
      reason: 'Ready',
      availableStorageBytes: 200,
    );
    await manager.download('small');
    expect(manager.error, isNull);
    expect(manager.downloadedIds, {'small'});
  });

  test(
    'unsupported backend cannot download and unknown storage is allowed',
    () async {
      backend.support = const LocalModelSupport(
        available: false,
        reason: 'No WebGPU',
      );
      await expectLater(manager.download('small'), failsWith('unavailable'));
      expect(manager.error, 'No WebGPU');
      expect(backend.trace, isNot(contains('download:small')));
      backend.support = const LocalModelSupport(
        available: true,
        reason: 'Ready',
      );
      await manager.download('small');
      expect(manager.downloadedIds, {'small'});
    },
  );

  test(
    'cached download is a no-op that preserves an already loaded model',
    () async {
      await ready();
      backend.support = const LocalModelSupport(
        available: true,
        reason: 'Ready',
        availableStorageBytes: 0,
      );
      await manager.download('small');
      expect(manager.loadedModelId, 'small');
      expect(manager.phase, LocalModelPhase.ready);
      expect(backend.trace, ['probe', 'inventory']);
    },
  );

  test(
    'a new download unloads weights without deleting earlier files',
    () async {
      await ready();
      await manager.download('large');
      expect(
        backend.trace.indexOf('unload'),
        lessThan(backend.trace.indexOf('download:large')),
      );
      expect(manager.loadedModelId, isNull);
      expect(manager.downloadedIds, {'small', 'large'});
    },
  );

  test(
    'failed transfers retain other cache and support an explicit retry',
    () async {
      backend.inventory.add('large');
      backend.downloadError = const AiServiceException(
        'storage',
        'Storage full.',
      );
      await expectLater(manager.download('small'), failsWith('storage'));
      expect(manager.downloadedIds, {'large'});
      expect(manager.isBusy, isFalse);
      backend.downloadError = null;
      await manager.download('small');
      expect(manager.downloadedIds, {'small', 'large'});
    },
  );

  test(
    'cancelled download ignores late progress and never becomes ready',
    () async {
      backend.inventory.add('large');
      backend.downloadGate = Completer<void>();
      backend.cancelSettlesDownload = false;
      final download = manager.download('small');
      final result = expectLater(download, failsWith('cancelled'));
      await flush();
      final staleProgress = backend.reportProgress!;
      await manager.cancelDownload();
      expect(manager.downloadedIds, {'large'});
      expect(manager.phase, LocalModelPhase.idle);
      staleProgress(const ModelDownloadProgress(message: 'Late', fraction: 1));
      backend.downloadGate!.complete();
      await result;
      expect(manager.progress, isNull);
      expect(manager.loadedModelId, isNull);
      expect(manager.error, isNull);
      expect(manager.downloadedIds, {'large'});
    },
  );

  test(
    'download cancellation stays busy until backend cleanup settles',
    () async {
      backend.downloadGate = Completer<void>();
      backend.cancelGate = Completer<void>();
      final download = manager.download('small');
      final result = expectLater(download, failsWith('cancelled'));
      await flush();
      final cancellation = manager.cancelDownload();
      await flush();
      expect(manager.isDownloading, isTrue);
      expect(manager.phase, LocalModelPhase.cancelling);
      await expectLater(manager.load('large'), failsWith('busy'));
      await expectLater(manager.download('large'), failsWith('busy'));
      backend.cancelGate!.complete();
      await cancellation;
      await result;
      expect(manager.isDownloading, isFalse);
      expect(manager.isBusy, isFalse);
    },
  );

  test('cancellation during preflight never starts a download', () async {
    await manager.initialize();
    backend.probeGate = Completer<void>();
    final download = manager.download('small');
    final result = expectLater(download, failsWith('cancelled'));
    await flush();
    await manager.cancelDownload();
    backend.probeGate!.complete();
    await result;
    expect(backend.trace, isNot(contains('download:small')));
    expect(manager.downloadedIds, isEmpty);
  });

  test('route and topic resets leave an active download running', () async {
    backend.downloadGate = Completer<void>();
    final download = manager.download('small');
    await flush();
    await manager.resetConversation();
    expect(manager.phase, LocalModelPhase.downloading);
    expect(manager.progress?.fraction, .25);
    expect(backend.trace, isNot(contains('reset')));
    expect(backend.trace, isNot(contains('cancelDownload')));
    await expectLater(manager.load('small'), failsWith('busy'));
    await expectLater(manager.remove('large'), failsWith('busy'));
    backend.downloadGate!.complete();
    await download;
    expect(manager.downloadedIds, {'small'});
  });

  test(
    'loading missing or unknown models never implicitly downloads',
    () async {
      await expectLater(manager.load('small'), failsWith('notDownloaded'));
      await expectLater(manager.load('unlisted'), failsWith('unknownModel'));
      expect(
        backend.trace.where((entry) => entry.startsWith('download:')),
        isEmpty,
      );
      expect(manager.loadedModelId, isNull);
    },
  );

  test(
    'allocation failure releases weights but preserves the cached model',
    () async {
      backend.inventory.add('small');
      backend.loadError = const AiServiceException(
        'outOfMemory',
        'Not enough memory.',
      );
      await expectLater(manager.load('small'), failsWith('outOfMemory'));
      expect(manager.loadedModelId, isNull);
      expect(manager.downloadedIds, {'small'});
      expect(manager.error, 'Not enough memory.');
      expect(
        backend.trace.lastIndexOf('unload'),
        greaterThan(backend.trace.indexOf('load:small')),
      );
      backend.loadError = null;
      await manager.load('small');
      expect(manager.phase, LocalModelPhase.ready);
    },
  );

  test('overlapping generation and model operations are rejected', () async {
    await ready();
    backend.responseGate = Completer<ConversationTurn>();
    final reply = respond();
    await flush();
    expect(manager.phase, LocalModelPhase.generating);
    await expectLater(respond(), failsWith('busy'));
    await expectLater(manager.load('large'), failsWith('busy'));
    await expectLater(manager.download('large'), failsWith('busy'));
    await expectLater(manager.remove('large'), failsWith('busy'));
    backend.responseGate!.complete(_turn);
    expect((await reply).reply, _turn.reply);
    expect(manager.phase, LocalModelPhase.ready);
    expect(backend.trace.where((entry) => entry == 'respond'), hasLength(1));
  });

  test('reset rejects a late response and serializes new generation', () async {
    await ready();
    backend.responseGate = Completer<ConversationTurn>();
    backend.resetGate = Completer<void>();
    final reply = respond();
    final replyResult = expectLater(reply, failsWith('cancelled'));
    await flush();
    final reset = manager.resetConversation();
    final secondReset = manager.resetConversation();
    expect(manager.isDownloading, isFalse);
    await expectLater(respond(), failsWith('busy'));
    backend.responseGate!.complete(_turn);
    await replyResult;
    backend.resetGate!.complete();
    await Future.wait([reset, secondReset]);
    expect(manager.loadedModelId, 'small');
    expect(manager.phase, LocalModelPhase.ready);
    expect(backend.trace.where((entry) => entry == 'reset'), hasLength(1));
    expect(manager.error, isNull);
  });

  test(
    'failed reset cannot advertise a loaded engine or reuse old context',
    () async {
      await ready();
      backend.resetError = const AiServiceException(
        'loadFailed',
        'Context reset failed.',
      );
      await expectLater(manager.resetConversation(), failsWith('loadFailed'));
      expect(manager.loadedModelId, isNull);
      expect(manager.downloadedIds, {'small'});
      expect(backend.trace, ['reset', 'unload']);
      await expectLater(respond(), failsWith('notLoaded'));
    },
  );

  test(
    'runtime loss during a reply clears loaded state without deleting files',
    () async {
      for (final code in [
        'outOfMemory',
        'runtimeLost',
        'timeout',
        'missingCache',
      ]) {
        await ready();
        backend.responseGate = Completer<ConversationTurn>();
        final reply = respond();
        final result = expectLater(reply, failsWith(code));
        await flush();
        backend.responseGate!.completeError(
          AiServiceException(code, 'Runtime unavailable.'),
        );
        await result;
        expect(manager.loadedModelId, isNull, reason: code);
        expect(manager.downloadedIds, {'small'});
        expect(backend.trace, ['respond', 'unload']);
      }
    },
  );

  test(
    'failed cache inspection does not advertise unverified downloaded files',
    () async {
      await ready();
      backend.inventoryError = const AiServiceException(
        'storage',
        'Storage is unavailable.',
      );
      await expectLater(manager.reconcile(), failsWith('storage'));
      expect(manager.downloadedIds, isEmpty);
      expect(manager.loadedModelId, isNull);
      expect(manager.phase, LocalModelPhase.error);
      backend.inventoryError = null;
      await manager.reconcile();
      expect(manager.downloadedIds, {'small'});
      expect(manager.loadedModelId, isNull);
      expect(manager.error, isNull);
    },
  );

  test('input and response validation protect alternate adapters', () async {
    await ready();
    await expectLater(respond(message: ''), failsWith('invalidInput'));
    expect(backend.trace, isNot(contains('respond')));
    backend.responseGate = Completer<ConversationTurn>()
      ..complete(
        const ConversationTurn(
          reply: '',
          suggestedReply: 'Hello',
          practiceGoal: 'Wait',
          followUpQuestion: 'Yes?',
        ),
      );
    await expectLater(respond(), failsWith('invalidResponse'));
    expect(manager.phase, LocalModelPhase.error);
  });

  test('removing another cached model preserves the active runtime', () async {
    await ready();
    backend.inventory.add('large');
    await manager.remove('large');
    expect(manager.loadedModelId, 'small');
    expect(manager.downloadedIds, {'small'});
    expect(manager.phase, LocalModelPhase.ready);
    expect(backend.trace, ['remove:large', 'inventory']);
    expect((await respond()).reply, _turn.reply);
  });

  test(
    'removing a loaded model unloads first and preserves unrelated files',
    () async {
      await ready();
      backend.inventory.add('large');
      await manager.setPreferredProvider('local:small');
      await manager.remove('small');
      expect(
        backend.trace.indexOf('unload'),
        lessThan(backend.trace.indexOf('remove:small')),
      );
      expect(manager.loadedModelId, isNull);
      expect(manager.downloadedIds, {'large'});
      expect(manager.preferredProvider, isNull);
    },
  );

  test(
    'removing an active transfer cancels before deleting only that model',
    () async {
      backend.inventory.add('large');
      backend.downloadGate = Completer<void>();
      final download = manager.download('small');
      final downloadResult = expectLater(download, failsWith('cancelled'));
      await flush();
      await manager.remove('small');
      await downloadResult;
      expect(
        backend.trace.indexOf('cancelDownload'),
        lessThan(backend.trace.indexOf('remove:small')),
      );
      expect(manager.downloadedIds, {'large'});
      expect(manager.phase, LocalModelPhase.idle);
    },
  );

  test('unsuccessful deletion remains visible and retryable', () async {
    await ready();
    backend.retainRemovedFile = true;
    await expectLater(manager.remove('small'), failsWith('removalFailed'));
    expect(manager.downloadedIds, {'small'});
    expect(manager.loadedModelId, isNull);
    backend.retainRemovedFile = false;
    await manager.remove('small');
    expect(manager.downloadedIds, isEmpty);
  });

  test(
    'reconciliation discovers eviction and unloads its stale runtime',
    () async {
      await ready();
      backend.inventory.clear();
      await manager.reconcile();
      expect(manager.downloadedIds, isEmpty);
      expect(manager.loadedModelId, isNull);
      expect(backend.trace, ['probe', 'inventory', 'unload']);
      await expectLater(manager.load('small'), failsWith('notDownloaded'));
    },
  );

  test(
    'provider preferences are serialized separately without conversation data',
    () async {
      await ready();
      await Future.wait([
        manager.setPreferredProvider('guided'),
        manager.setPreferredProvider('apple'),
        manager.setPreferredProvider('local:small'),
      ]);
      await respond(message: 'This message must stay ephemeral.');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), {LocalModelManager.preferencesKey});
      expect(jsonDecode(prefs.getString(LocalModelManager.preferencesKey)!), {
        'version': 1,
        'preferredProvider': 'local:small',
      });
      await expectLater(
        manager.setPreferredProvider('local:unknown'),
        failsWith('unknownProvider'),
      );
      expect(manager.preferredProvider, 'local:small');
      await manager.setPreferredProvider(null);
      expect(prefs.containsKey(LocalModelManager.preferencesKey), isFalse);
    },
  );

  test('disposal cancels transfers and makes late callbacks inert', () async {
    backend.downloadGate = Completer<void>();
    final download = manager.download('small');
    final downloadResult = expectLater(download, failsWith('cancelled'));
    await flush();
    var notifications = 0;
    manager.addListener(() => notifications++);
    final lateProgress = backend.reportProgress!;
    manager.dispose();
    lateProgress(
      const ModelDownloadProgress(message: 'Late progress', fraction: 1),
    );
    await manager.shutdownComplete;
    await downloadResult;
    expect(notifications, 0);
    expect(manager.loadedModelId, isNull);
    expect(manager.progress, isNull);
    expect(backend.trace.sublist(backend.trace.length - 3), [
      'cancelDownload',
      'unload',
      'dispose',
    ]);
    await expectLater(manager.load('small'), failsWith('disposed'));
  });

  test('disposal during loading does not publish late ready state', () async {
    backend.inventory.add('small');
    backend.loadGate = Completer<void>();
    final loading = manager.load('small');
    final loadingResult = expectLater(loading, failsWith('cancelled'));
    await flush();
    manager.dispose();
    backend.loadGate!.complete();
    await loadingResult;
    await manager.shutdownComplete;
    expect(manager.loadedModelId, isNull);
    expect(manager.phase, LocalModelPhase.idle);
  });
}
