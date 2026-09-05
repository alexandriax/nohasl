import 'dart:convert';
import 'dart:js_interop';

import '../conversation/apple_intelligence.dart';
import 'local_model_backend.dart';
import 'local_model_prompt.dart';

@JS('nohaslLocalModels')
external JSObject? get _localModelBridge;

@JS('nohaslLocalModels.invoke')
external JSPromise<JSString> _invokeLocalModelBridge(
  JSString request,
  JSFunction? progressCallback,
);

LocalModelBackend createLocalModelBackend() => WebLocalModelBackend();

/// Text-only inference in a bundled Web Worker. No prompt, camera frame, or
/// conversation is sent to a server. Only explicit downloads fetch model files.
class WebLocalModelBackend extends LocalModelBackend {
  bool _disposed = false;

  @override
  List<LocalModelSpec> get models => const [
    LocalModelSpec(
      id: 'SmolLM2-360M-Instruct-q4f16_1-MLC',
      name: 'SmolLM2 · 360M',
      description:
          'Experimental, small English role-play model. Replies may be repetitive '
          'or inaccurate. About 0.4 GiB GPU memory plus browser overhead. Requires WebGPU shader-f16.',
      downloadBytes: 211553449,
      memoryGiB: 0.4,
      license: 'Apache 2.0',
      licenseUrl: 'https://www.apache.org/licenses/LICENSE-2.0',
      sourceUrl:
          'https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC',
      revision: '3a622fd89e0216e8bb10c410c007c786baa8a033',
    ),
    LocalModelSpec(
      id: 'gemma-2-2b-it-q4f16_1-MLC',
      name: 'Gemma 2 · 2B',
      description:
          'Experimental, larger English role-play model. About 1.9 GiB GPU memory '
          'plus browser overhead. Requires WebGPU shader-f16.',
      downloadBytes: 1493768395,
      memoryGiB: 1.9,
      license: 'Gemma Terms of Use',
      licenseUrl: 'https://ai.google.dev/gemma/terms',
      sourceUrl: 'https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC',
      revision: 'de9cc76f0d4b3a49a0f718df424944054bf1eec1',
      termsNotice:
          'Gemma 2 is governed by Google’s Gemma Terms of Use and '
          'prohibited-use policy. Review those linked terms before downloading. '
          'The public converted model remains subject to those terms.',
    ),
  ];

  Future<Object?> _invoke(
    String operation, {
    Map<String, Object?> arguments = const {},
    void Function(ModelDownloadProgress)? onProgress,
  }) async {
    if (_disposed) {
      throw const AiServiceException(
        'disposed',
        'This local model session has closed.',
      );
    }
    if (_localModelBridge == null) {
      throw const AiServiceException(
        'runtimeMissing',
        'This web build does not include the local model runtime. '
            'Guided rehearsal is still available.',
      );
    }
    void progress(JSString raw) {
      try {
        final data = jsonDecode(raw.toDart) as Map<String, dynamic>;
        final fraction = data['fraction'];
        final downloaded = data['downloadedBytes'];
        final total = data['totalBytes'];
        onProgress?.call(
          ModelDownloadProgress(
            message: data['message'] is String
                ? data['message'] as String
                : 'Preparing the local model…',
            fraction: fraction is num ? fraction.toDouble().clamp(0, 1) : null,
            downloadedBytes: downloaded is num ? downloaded.toInt() : null,
            totalBytes: total is num ? total.toInt() : null,
          ),
        );
      } on FormatException {
        // A malformed progress event cannot complete or fail an operation.
      }
    }

    try {
      final raw = await _invokeLocalModelBridge(
        jsonEncode({'op': operation, 'args': arguments}).toJS,
        onProgress == null ? null : progress.toJS,
      ).toDart;
      final result = jsonDecode(raw.toDart) as Map<String, dynamic>;
      if (result['ok'] != true) {
        final details = result['error'];
        throw AiServiceException(
          details is Map && details['code'] is String
              ? details['code'] as String
              : 'runtimeError',
          details is Map && details['message'] is String
              ? details['message'] as String
              : 'The local model could not complete this operation.',
        );
      }
      return result['value'];
    } on AiServiceException {
      rethrow;
    } catch (_) {
      throw const AiServiceException(
        'runtimeError',
        'The browser could not run the local model. Please retry or use guided rehearsal.',
      );
    }
  }

  @override
  Future<LocalModelSupport> probe() async {
    try {
      final result = await _invoke('probe') as Map<String, dynamic>;
      final storage = result['availableStorageBytes'];
      return LocalModelSupport(
        available: result['available'] == true,
        reason: result['reason'] as String,
        availableStorageBytes: storage is num ? storage.toInt() : null,
      );
    } on AiServiceException catch (error) {
      return LocalModelSupport(available: false, reason: error.message);
    }
  }

  @override
  Future<Set<String>> downloadedModels() async {
    final result = await _invoke('downloadedModels') as List<dynamic>;
    final offered = models.map((model) => model.id).toSet();
    return result.whereType<String>().where(offered.contains).toSet();
  }

  @override
  Future<void> download(
    String modelId,
    void Function(ModelDownloadProgress) onProgress,
  ) async {
    await _invoke(
      'download',
      arguments: {'modelId': modelId},
      onProgress: onProgress,
    );
  }

  @override
  Future<void> cancelDownload() async {
    await _invoke('cancelDownload');
  }

  @override
  Future<void> load(String modelId) async {
    await _invoke('load', arguments: {'modelId': modelId});
  }

  @override
  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) async {
    final messages = localConversationMessages(
      topic: topic,
      level: level,
      message: message,
      history: history,
    );
    final output = await _invoke(
      'respond',
      arguments: {'messages': messages, 'schema': localConversationSchema},
    );
    if (output is! String) {
      throw const AiServiceException(
        'invalidResponse',
        'The model returned an incomplete reply. Please try again.',
      );
    }
    return parseLocalConversation(output);
  }

  @override
  Future<void> reset() async {
    if (!_disposed) await _invoke('reset');
  }

  @override
  Future<void> unload() async {
    if (!_disposed) await _invoke('unload');
  }

  @override
  Future<void> remove(String modelId) async {
    await _invoke('remove', arguments: {'modelId': modelId});
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    try {
      await _invoke('dispose');
    } finally {
      _disposed = true;
    }
  }
}
