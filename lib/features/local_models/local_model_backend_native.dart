import 'dart:async';
import 'dart:ffi' show Abi;
import 'dart:io';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:llamadart/llamadart.dart' as llama;
import 'package:path_provider/path_provider.dart';

import '../conversation/apple_intelligence.dart';
import 'local_model_backend.dart';
import 'local_model_prompt.dart';

LocalModelBackend createLocalModelBackend() => NativeLocalModelBackend();

const _model = LocalModelSpec(
  id: 'qwen25-05b-q4km',
  name: 'Qwen 2.5 · Compact',
  description:
      'An experimental, compact English conversation partner. Quick to try, with less '
      'nuance than larger models. It does not assess or translate signing.',
  downloadBytes: 491400032,
  memoryGiB: 1.2,
  license: 'Apache 2.0',
  licenseUrl:
      'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/blob/'
      '9217f5db79a29953eb74d5343926648285ec7e67/LICENSE',
  sourceUrl: 'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF',
  revision: '9217f5db79a29953eb74d5343926648285ec7e67',
);
const _fileName = 'qwen2.5-0.5b-instruct-q4_k_m.gguf';
const _sha256 =
    '74a4da8c9fdbcd15bd1f6d01d621410d31c6fc00986f5eb687824e7b93d7a9db';
const _downloadUrl =
    'https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/'
    '9217f5db79a29953eb74d5343926648285ec7e67/$_fileName';

/// Owns a bundled, in-process llama.cpp runtime and one allowlisted model.
/// Construction/probing never starts the runtime or downloads data.
class NativeLocalModelBackend extends LocalModelBackend {
  NativeLocalModelBackend({Future<Directory> Function()? cacheDirectory})
    : _cacheDirectoryProvider = cacheDirectory ?? getApplicationCacheDirectory;

  final Future<Directory> Function() _cacheDirectoryProvider;
  Future<Directory>? _directory;
  llama.LlamaEngine? _engine;
  String? _loadedId;
  Future<void> _engineTail = Future<void>.value();
  Future<void>? _downloadFuture;
  HttpClient? _downloadClient;
  bool _downloadCancelled = false;
  bool _responding = false;
  bool _removing = false;
  bool _disposed = false;
  int _epoch = 0;
  Timer? _cancellationTimer;

  @override
  List<LocalModelSpec> get models => const [_model];

  @override
  Future<LocalModelSupport> probe() async {
    final supported = const [
      Abi.macosArm64,
      Abi.macosX64,
      Abi.windowsArm64,
      Abi.windowsX64,
      Abi.linuxArm64,
      Abi.linuxX64,
      Abi.androidArm64,
      Abi.androidX64,
      Abi.iosArm64,
      Abi.iosX64,
    ].contains(Abi.current());
    return LocalModelSupport(
      available: supported && !_disposed,
      reason: supported
          ? 'Models run on this device after an optional download. '
                'Storage and memory requirements vary by device.'
          : 'Downloadable models require a supported 64-bit device.',
    );
  }

  void _checkAlive() {
    if (_disposed) {
      throw const AiServiceException('disposed', 'The local model was closed.');
    }
  }

  void _checkModel(String id) {
    _checkAlive();
    if (id != _model.id) {
      throw const AiServiceException('unknownModel', 'Choose a listed model.');
    }
  }

  Future<Directory> _root() {
    final cached = _directory;
    if (cached != null) return cached;
    final created = () async {
      final base = await _cacheDirectoryProvider();
      final directory = Directory('${base.path}/nohasl_local_models');
      await directory.create(recursive: true);
      return directory;
    }();
    _directory = created;
    return created.catchError((Object error, StackTrace stack) {
      if (identical(_directory, created)) _directory = null;
      Error.throwWithStackTrace(error, stack);
    });
  }

  Future<File> _file({bool partial = false}) async =>
      File('${(await _root()).path}/$_fileName${partial ? '.part' : ''}');

  // Serializing all runtime operations prevents native model/context frees
  // racing a decode. Cancellation signals the native flag before joining this
  // queue; a stale completion can never escape as a successful response.
  Future<T> _withEngine<T>(Future<T> Function() action) {
    final result = _engineTail.then((_) => action());
    _engineTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return result;
  }

  void _cancelGeneration() {
    final engine = _engine;
    engine?.cancelGeneration();
    _cancellationTimer?.cancel();
    if (!_responding || engine == null) return;
    // llama.cpp's cancel flag exists only once decode starts. Keep signalling
    // across the asynchronous chat-template/prefill boundary so an immediate
    // reset cannot miss a generation that has not created its native flag yet.
    _cancellationTimer = Timer.periodic(const Duration(milliseconds: 20), (
      timer,
    ) {
      if (!_responding || !identical(engine, _engine)) {
        timer.cancel();
      } else {
        engine.cancelGeneration();
      }
    });
  }

  Future<bool> _validFile(File file) async {
    if (!await file.exists()) return false;
    if (await FileSystemEntity.type(file.path, followLinks: false) !=
            FileSystemEntityType.file ||
        await file.length() != _model.downloadBytes) {
      return false;
    }
    return (await sha256.bind(file.openRead()).first).toString() == _sha256;
  }

  @override
  Future<Set<String>> downloadedModels() async {
    _checkAlive();
    return await _validFile(await _file()) ? {_model.id} : <String>{};
  }

  @override
  Future<void> download(
    String modelId,
    void Function(ModelDownloadProgress) onProgress,
  ) {
    _checkModel(modelId);
    if (_downloadFuture != null || _removing) {
      throw const AiServiceException(
        'busy',
        'A model download is in progress.',
      );
    }
    _downloadCancelled = false;
    final future = _performDownload(onProgress);
    _downloadFuture = future;
    return future.whenComplete(() {
      if (identical(_downloadFuture, future)) _downloadFuture = null;
    });
  }

  void _checkDownload() {
    if (_disposed || _downloadCancelled) {
      throw const AiServiceException('cancelled', 'Model download cancelled.');
    }
  }

  Future<void> _performDownload(
    void Function(ModelDownloadProgress) onProgress,
  ) async {
    final partial = await _file(partial: true);
    final target = await _file();
    HttpClient? client;
    IOSink? sink;
    try {
      _checkDownload();
      await unload();
      _checkDownload();
      final alreadyDownloaded = await _validFile(target);
      _checkDownload();
      if (alreadyDownloaded) return;
      // We deliberately restart incomplete downloads. A partial is never
      // exposed as ready, and the final rename occurs only after verification.
      if (await partial.exists()) await partial.delete();
      client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
      _downloadClient = client;
      final request = await client
          .getUrl(Uri.parse(_downloadUrl))
          .timeout(const Duration(seconds: 30));
      _checkDownload();
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      if (response.statusCode != HttpStatus.ok) {
        throw const AiServiceException(
          'downloadFailed',
          'The model host could not serve this download. Please retry.',
        );
      }
      if (response.contentLength >= 0 &&
          response.contentLength != _model.downloadBytes) {
        throw const AiServiceException(
          'integrity',
          'The model download does not match this release. Please retry.',
        );
      }
      sink = partial.openWrite();
      var received = 0;
      var lastReport = DateTime.fromMillisecondsSinceEpoch(0);
      await for (final bytes in response.timeout(const Duration(seconds: 30))) {
        _checkDownload();
        received += bytes.length;
        if (received > _model.downloadBytes) {
          throw const AiServiceException(
            'integrity',
            'The downloaded file is larger than this release.',
          );
        }
        sink.add(bytes);
        // Flush periodically for bounded buffering/backpressure on slow disks.
        if (DateTime.now().difference(lastReport).inMilliseconds >= 150) {
          await sink.flush();
          _checkDownload();
          onProgress(
            ModelDownloadProgress(
              message: 'Downloading model',
              fraction: received / _model.downloadBytes,
              downloadedBytes: received,
              totalBytes: _model.downloadBytes,
            ),
          );
          lastReport = DateTime.now();
        }
      }
      await sink.flush();
      await sink.close();
      sink = null;
      _checkDownload();
      onProgress(
        ModelDownloadProgress(
          message: 'Verifying model integrity',
          fraction: 1,
          downloadedBytes: _model.downloadBytes,
          totalBytes: _model.downloadBytes,
        ),
      );
      if (!await _validFile(partial)) {
        throw const AiServiceException(
          'integrity',
          'Model verification failed. Nothing was installed. Please retry.',
        );
      }
      _checkDownload();
      if (await target.exists()) await target.delete();
      _checkDownload();
      await partial.rename(target.path);
      // A cancel arriving during filesystem rename must remove that result.
      if (_downloadCancelled || _disposed) {
        await target.delete();
        _checkDownload();
      }
    } catch (error) {
      if (_downloadCancelled || _disposed) {
        throw const AiServiceException(
          'cancelled',
          'Model download cancelled.',
        );
      }
      if (error is AiServiceException) rethrow;
      if (error is FileSystemException) {
        throw const AiServiceException(
          'storage',
          'The model could not be saved. Check available storage and retry.',
        );
      }
      throw const AiServiceException(
        'downloadFailed',
        'The download was interrupted. Check your connection and retry.',
      );
    } finally {
      client?.close(force: true);
      if (identical(_downloadClient, client)) _downloadClient = null;
      try {
        await sink?.close();
      } catch (_) {}
      if (await partial.exists()) await partial.delete();
    }
  }

  @override
  Future<void> cancelDownload() async {
    _downloadCancelled = true;
    _downloadClient?.close(force: true);
    try {
      await _downloadFuture;
    } catch (_) {}
  }

  @override
  Future<void> load(String modelId) {
    _checkModel(modelId);
    if (_downloadFuture != null || _removing) {
      throw const AiServiceException(
        'busy',
        'Wait for the download to finish.',
      );
    }
    return _withEngine(() async {
      _checkAlive();
      if (_loadedId == modelId && _engine?.isReady == true) return;
      final file = await _file();
      if (!await _validFile(file)) {
        throw const AiServiceException(
          'notDownloaded',
          'Download this model before loading it.',
        );
      }
      await _releaseEngine();
      await _loadFile(file.path, modelId);
    });
  }

  Future<void> _loadFile(String path, String id) async {
    _checkAlive();
    final engine = llama.LlamaEngine(llama.LlamaBackend());
    _engine = engine;
    try {
      await engine.setLogLevel(llama.LlamaLogLevel.none);
      await engine.loadModel(
        path,
        modelParams: llama.ModelParams(
          contextSize: 4096,
          // iOS CPU keeps simulator and device behavior predictable. Metal is
          // enabled on macOS; other native targets have CPU-only build bundles.
          gpuLayers: Platform.isMacOS ? 99 : 0,
          preferredBackend: Platform.isMacOS
              ? llama.GpuBackend.metal
              : llama.GpuBackend.cpu,
          numberOfThreads: math.min(4, Platform.numberOfProcessors),
          numberOfThreadsBatch: math.min(4, Platform.numberOfProcessors),
          batchSize: 256,
          microBatchSize: 128,
        ),
      );
      _checkAlive();
      _loadedId = id;
    } catch (_) {
      await _releaseEngine();
      throw const AiServiceException(
        'loadFailed',
        'This device could not load the model. Close other apps or use guided rehearsal.',
      );
    }
  }

  @override
  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) {
    _checkAlive();
    if (_responding) {
      throw const AiServiceException('busy', 'Wait for the current reply.');
    }
    final prompt = localConversationMessages(
      topic: topic,
      level: level,
      message: message,
      history: history,
    );
    final epoch = _epoch;
    _responding = true;
    return _withEngine(() async {
      final engine = _engine;
      if (epoch != _epoch || _disposed) {
        throw const AiServiceException('cancelled', 'Conversation reset.');
      }
      if (engine == null || !engine.isReady) {
        throw const AiServiceException(
          'notLoaded',
          'Load a downloaded model first.',
        );
      }
      var timedOut = false;
      final timer = Timer(const Duration(seconds: 60), () {
        timedOut = true;
        _cancelGeneration();
      });
      try {
        final output = llama.LlamaStructuredOutput<ConversationTurn>.jsonSchema(
          schema: localConversationSchema,
          decoder: ConversationTurn.fromMap,
        );
        final result = await engine.createStructuredJson<ConversationTurn>(
          prompt
              .map(
                (entry) => llama.LlamaChatMessage.fromText(
                  role: entry['role'] == 'system'
                      ? llama.LlamaChatRole.system
                      : llama.LlamaChatRole.user,
                  text: entry['content']!,
                ),
              )
              .toList(),
          output: output,
          params: const llama.GenerationParams(
            maxTokens: 320,
            temp: 0.5,
            reusePromptPrefix: false,
          ),
          enableThinking: false,
        );
        if (timedOut) {
          throw const AiServiceException(
            'timeout',
            'This reply took too long. Try a shorter message.',
          );
        }
        if (epoch != _epoch || _disposed) {
          throw const AiServiceException('cancelled', 'Conversation reset.');
        }
        return result;
      } catch (error) {
        if (epoch != _epoch || _disposed) {
          throw const AiServiceException('cancelled', 'Conversation reset.');
        }
        if (timedOut) {
          throw const AiServiceException(
            'timeout',
            'This reply took too long. Try a shorter message.',
          );
        }
        if (error is AiServiceException) rethrow;
        throw const AiServiceException(
          'generationFailed',
          'The model could not finish this reply. Retry, shorten your message, or use guided rehearsal.',
        );
      } finally {
        timer.cancel();
      }
    }).whenComplete(() {
      _responding = false;
      _cancellationTimer?.cancel();
    });
  }

  @override
  Future<void> reset() {
    ++_epoch;
    _cancelGeneration();
    return _withEngine(() async {
      if (_disposed) return;
      final id = _loadedId;
      if (id == null) return;
      // The package has no public clear-context operation. Reopen the cached
      // model to release the old KV context without any network request.
      await _releaseEngine();
      final file = await _file();
      if (!await _validFile(file)) {
        throw const AiServiceException(
          'notDownloaded',
          'The cached model is missing or changed. Download it again.',
        );
      }
      await _loadFile(file.path, id);
    });
  }

  Future<void> _releaseEngine() async {
    final engine = _engine;
    _engine = null;
    _loadedId = null;
    await engine?.dispose();
  }

  @override
  Future<void> unload() {
    ++_epoch;
    _cancelGeneration();
    return _withEngine(_releaseEngine);
  }

  @override
  Future<void> remove(String modelId) async {
    _checkModel(modelId);
    if (_removing) {
      throw const AiServiceException('busy', 'Model removal is in progress.');
    }
    _removing = true;
    try {
      await cancelDownload();
      await unload();
      for (final partial in [false, true]) {
        final file = await _file(partial: partial);
        if (await file.exists()) await file.delete();
      }
    } finally {
      _removing = false;
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await cancelDownload();
    await unload();
  }
}
