import 'local_model_backend.dart';
import '../conversation/apple_intelligence.dart';

LocalModelBackend createLocalModelBackend() => UnsupportedLocalModelBackend();

class UnsupportedLocalModelBackend extends LocalModelBackend {
  @override
  List<LocalModelSpec> get models => const [];
  @override
  Future<LocalModelSupport> probe() async => const LocalModelSupport(
    available: false,
    reason:
        'Downloadable models are unavailable in this environment. Guided rehearsal is always available.',
  );
  @override
  Future<Set<String>> downloadedModels() async => {};
  @override
  Future<void> download(
    String modelId,
    void Function(ModelDownloadProgress) onProgress,
  ) async => _unsupported();
  @override
  Future<void> cancelDownload() async {}
  @override
  Future<void> load(String modelId) async => _unsupported();
  @override
  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) async => _unsupported();
  @override
  Future<void> reset() async {}
  @override
  Future<void> unload() async {}
  @override
  Future<void> remove(String modelId) async {}
  @override
  Future<void> dispose() async {}
  Never _unsupported() => throw const AiServiceException(
    'unsupportedPlatform',
    'Local models are not supported in this environment.',
  );
}
