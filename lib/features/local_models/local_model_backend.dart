import '../conversation/apple_intelligence.dart';

/// A pinned model release offered by this build, not an arbitrary model URL.
class LocalModelSpec {
  const LocalModelSpec({
    required this.id,
    required this.name,
    required this.description,
    required this.downloadBytes,
    required this.memoryGiB,
    required this.license,
    required this.licenseUrl,
    required this.sourceUrl,
    required this.revision,
    this.termsNotice,
  });
  final String id;
  final String name;
  final String description;
  final int downloadBytes;

  /// Planning estimate, not a guarantee or measured free memory.
  final double memoryGiB;
  final String license;
  final String licenseUrl;
  final String sourceUrl;
  final String revision;
  final String? termsNotice;

  String get downloadLabel => downloadBytes >= 1000000000
      ? '${(downloadBytes / 1000000000).toStringAsFixed(1)} GB'
      : '${(downloadBytes / 1000000).ceil()} MB';
}

class LocalModelSupport {
  const LocalModelSupport({
    required this.available,
    required this.reason,
    this.availableStorageBytes,
  });
  final bool available;
  final String reason;
  final int? availableStorageBytes;
}

class ModelDownloadProgress {
  const ModelDownloadProgress({
    required this.message,
    this.fraction,
    this.downloadedBytes,
    this.totalBytes,
  });
  final String message;
  final double? fraction;
  final int? downloadedBytes;
  final int? totalBytes;
}

/// Runtime boundary. Creating/probing an adapter must not download model data.
/// Implementations serialize their engine operations and reject stale results.
/// Downloads survive conversation reset; cancellation/deletion are explicit.
abstract class LocalModelBackend {
  List<LocalModelSpec> get models;
  Future<LocalModelSupport> probe();

  /// Return only complete cached artifacts; never trust a preferences flag alone.
  Future<Set<String>> downloadedModels();

  /// Download a known pinned release after the learner's explicit choice.
  /// May compile/validate it, but must release inference memory before returning.
  Future<void> download(
    String modelId,
    void Function(ModelDownloadProgress) onProgress,
  );

  /// Must settle the canceled download and prevent it from later becoming ready.
  Future<void> cancelDownload();

  /// Load a fully cached model. Missing artifacts must not trigger a silent fetch.
  Future<void> load(String modelId);
  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  });

  /// Cancel generation/forget context, preserving downloads and loaded weights.
  Future<void> reset();

  /// Release inference memory without deleting the model.
  Future<void> unload();

  /// Delete this model's artifacts only (including any of its partial download).
  /// Preserve every other model's cache and any different model's loaded runtime.
  Future<void> remove(String modelId);
  Future<void> dispose();
}
