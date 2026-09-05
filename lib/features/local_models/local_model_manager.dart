import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conversation/apple_intelligence.dart';
import 'local_model_backend.dart';
import 'local_model_prompt.dart';

enum LocalModelPhase {
  checking,
  idle,
  downloading,
  cancelling,
  loading,
  ready,
  generating,
  removing,
  error,
}

/// App-scoped owner of optional model files and one local inference runtime.
///
/// Cached files are always discovered through the backend. Preferences contain
/// only the learner's provider choice, never installation flags or conversation
/// content. Construction and initialization cannot download or load a model.
class LocalModelManager extends ChangeNotifier {
  LocalModelManager(LocalModelBackend backend) : _backend = backend;

  static const preferencesKey = 'nohasl.models.v1';
  final LocalModelBackend _backend;
  LocalModelBackend get backend => _backend;
  List<LocalModelSpec> get models => List.unmodifiable(_backend.models);
  LocalModelSupport? get support => _support;
  Set<String> get downloadedIds => Set.unmodifiable(_downloadedIds);
  String? get loadedModelId => _loadedModelId;
  String? get workingModelId => _workingModelId;
  LocalModelPhase get phase => _phase;
  ModelDownloadProgress? get progress => _progress;
  String? get error => _error;
  String? get errorCode => _errorCode;
  String? get preferredProvider => _preferredProvider;
  bool get isDownloading =>
      _phase == LocalModelPhase.downloading ||
      (_phase == LocalModelPhase.cancelling && _cancellation != null);
  bool get isBusy => switch (_phase) {
    LocalModelPhase.checking ||
    LocalModelPhase.downloading ||
    LocalModelPhase.cancelling ||
    LocalModelPhase.loading ||
    LocalModelPhase.generating ||
    LocalModelPhase.removing => true,
    _ => false,
  };

  LocalModelSupport? _support;
  Set<String> _downloadedIds = {};
  String? _loadedModelId;
  String? _workingModelId;
  LocalModelPhase _phase = LocalModelPhase.idle;
  ModelDownloadProgress? _progress;
  String? _error;
  String? _errorCode;
  String? _preferredProvider;
  SharedPreferences? _preferences;
  Future<void>? _initialization;
  Future<void>? _cancellation;
  Future<void>? _resetting;
  Future<void> _preferenceTail = Future<void>.value();
  Future<void> _shutdown = Future<void>.value();
  bool _initialized = false;
  bool _disposed = false;
  int _epoch = 0;

  /// Allows app owners/tests to await cleanup after synchronous [dispose].
  Future<void> get shutdownComplete => _shutdown;

  Future<void> initialize() {
    _checkAlive();
    if (_initialized) return Future<void>.value();
    return _initialization ??= _run<void>(LocalModelPhase.checking, null, (
      ticket,
    ) async {
      final preferences = await SharedPreferences.getInstance();
      _checkCurrent(ticket);
      _preferences = preferences;
      try {
        final raw = preferences.getString(preferencesKey);
        final value = raw == null ? null : jsonDecode(raw);
        if (value is Map &&
            value['version'] == 1 &&
            _validPreference(value['preferredProvider'])) {
          _preferredProvider = value['preferredProvider'] as String?;
        }
      } on FormatException {
        // A damaged preference never implies consent to fetch or load files.
      } on TypeError {
        // Recover from an older or otherwise incompatible preference value.
      }
      await _refresh(ticket);
      _initialized = true;
    }).whenComplete(() => _initialization = null);
  }

  /// Recheck actual storage, including browser eviction. A foreground operation
  /// already reconciles its files; a lifecycle check must not interrupt it.
  Future<void> reconcile() async {
    await initialize();
    _checkAlive();
    if (isBusy) return;
    await _run<void>(LocalModelPhase.checking, null, _refresh);
  }

  Future<void> _refresh(int ticket) async {
    final support = await _backend.probe();
    _checkCurrent(ticket);
    _support = support;
    await _refreshInventory(ticket);
    if (!support.available && _loadedModelId != null) {
      _loadedModelId = null;
      await _backend.unload();
      _checkCurrent(ticket);
    }
  }

  Future<void> _refreshInventory(int ticket) async {
    final Set<String> actual;
    try {
      actual = await _backend.downloadedModels();
    } catch (_) {
      if (_current(ticket)) {
        _downloadedIds = {};
        if (_loadedModelId != null) {
          _loadedModelId = null;
          await _quietUnload();
        }
      }
      rethrow;
    }
    _checkCurrent(ticket);
    final known = models.map((model) => model.id).toSet();
    _downloadedIds = actual.intersection(known);
    if (_loadedModelId != null && !_downloadedIds.contains(_loadedModelId)) {
      _loadedModelId = null;
      await _backend.unload();
      _checkCurrent(ticket);
    }
  }

  Future<void> download(String id) async {
    await initialize();
    final model = _model(id);
    await _run<void>(LocalModelPhase.downloading, id, (ticket) async {
      await _refresh(ticket);
      _requireSupport();
      if (_downloadedIds.contains(id)) return;
      final free = _support?.availableStorageBytes;
      if (free != null && free < model.downloadBytes * 2) {
        throw const AiServiceException(
          'insufficientStorage',
          'There is not enough free storage to install this model. Allow about '
              'twice the download size during installation, then retry.',
        );
      }
      // Some backends validate a download by compiling it with their one engine.
      // Releasing existing weights first keeps the public runtime state honest.
      if (_loadedModelId != null) {
        _loadedModelId = null;
        await _backend.unload();
        _checkCurrent(ticket);
      }
      try {
        await _backend.download(id, (value) {
          if (!_current(ticket)) return;
          _progress = value;
          _notify();
        });
        _checkCurrent(ticket);
        await _refreshInventory(ticket);
        if (!_downloadedIds.contains(id)) {
          throw const AiServiceException(
            'downloadIncomplete',
            'The complete model is not available in storage. Please retry.',
          );
        }
      } catch (_) {
        if (_current(ticket)) await _tryRefreshInventory(ticket);
        rethrow;
      }
    });
  }

  Future<void> cancelDownload() {
    _checkAlive();
    if (_cancellation != null) return _cancellation!;
    if (_phase != LocalModelPhase.downloading) return Future<void>.value();
    final id = _workingModelId;
    // Invalidate callbacks before asking the backend to settle the transfer.
    return _cancellation = _run<void>(LocalModelPhase.cancelling, id, (
      ticket,
    ) async {
      await _backend.cancelDownload();
      _checkCurrent(ticket);
      await _refreshInventory(ticket);
    }, interrupt: true).whenComplete(() => _cancellation = null);
  }

  Future<void> load(String id) async {
    await initialize();
    _model(id);
    await _run<void>(LocalModelPhase.loading, id, (ticket) async {
      await _refresh(ticket);
      _requireSupport();
      if (!_downloadedIds.contains(id)) {
        throw const AiServiceException(
          'notDownloaded',
          'Download this model before using it.',
        );
      }
      if (_loadedModelId == id) return;
      _loadedModelId = null;
      await _backend.unload();
      _checkCurrent(ticket);
      try {
        await _backend.load(id);
        _checkCurrent(ticket);
        _loadedModelId = id;
      } catch (_) {
        if (_current(ticket)) {
          // A partial allocation or failed context must not appear as ready.
          await _quietUnload();
          await _tryRefreshInventory(ticket);
        }
        rethrow;
      }
    });
  }

  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) async {
    await initialize();
    _checkIdle();
    if (_loadedModelId == null) {
      throw const AiServiceException(
        'notLoaded',
        'Choose a downloaded model first.',
      );
    }
    // Validate before entering the runtime, even for alternate/test adapters.
    localConversationMessages(
      topic: topic,
      level: level,
      message: message,
      history: history,
    );
    return _run<ConversationTurn>(LocalModelPhase.generating, _loadedModelId, (
      ticket,
    ) async {
      final ConversationTurn result;
      try {
        result = await _backend.respond(
          topic: topic,
          level: level,
          message: message,
          history: history,
        );
      } on AiServiceException catch (failure) {
        if (_current(ticket) &&
            const {
              'outOfMemory',
              'notLoaded',
              'loadFailed',
              'deviceLost',
              'runtimeLost',
              'runtimeError',
              'missingCache',
              'timeout',
            }.contains(failure.code)) {
          _loadedModelId = null;
          await _quietUnload();
        }
        rethrow;
      }
      _checkCurrent(ticket);
      return ConversationTurn.fromMap({
        'reply': result.reply,
        'suggestedReply': result.suggestedReply,
        'practiceGoal': result.practiceGoal,
        'followUpQuestion': result.followUpQuestion,
      });
    });
  }

  /// Changing a topic/route cancels replies, never an unrelated model download.
  /// Loading and downloading start with fresh context, so no reset is needed.
  Future<void> resetConversation() {
    _checkAlive();
    if (_resetting != null) return _resetting!;
    if (_phase == LocalModelPhase.downloading ||
        _phase == LocalModelPhase.loading ||
        _phase == LocalModelPhase.checking ||
        _phase == LocalModelPhase.removing ||
        _cancellation != null) {
      return Future<void>.value();
    }
    if (_loadedModelId == null && _phase != LocalModelPhase.generating) {
      return Future<void>.value();
    }
    return _resetting = _run<void>(
      LocalModelPhase.cancelling,
      _loadedModelId,
      (ticket) async {
        try {
          await _backend.reset();
          _checkCurrent(ticket);
        } catch (_) {
          if (_current(ticket)) {
            _loadedModelId = null;
            await _quietUnload();
          }
          rethrow;
        }
      },
      interrupt: _phase == LocalModelPhase.generating,
    ).whenComplete(() => _resetting = null);
  }

  Future<void> unload() async {
    _checkAlive();
    if (_phase == LocalModelPhase.generating || _resetting != null) {
      await resetConversation();
    }
    await _run<void>(LocalModelPhase.loading, _loadedModelId, (ticket) async {
      _loadedModelId = null;
      await _backend.unload();
      _checkCurrent(ticket);
    });
  }

  Future<void> remove(String id) async {
    await initialize();
    _model(id);
    if (_workingModelId == id &&
        (_phase == LocalModelPhase.downloading || _cancellation != null)) {
      await cancelDownload();
    }
    if (_loadedModelId == id &&
        (_phase == LocalModelPhase.generating || _resetting != null)) {
      await resetConversation();
    }
    await _run<void>(LocalModelPhase.removing, id, (ticket) async {
      if (_loadedModelId == id) {
        _loadedModelId = null;
        await _backend.unload();
        _checkCurrent(ticket);
      }
      try {
        await _backend.remove(id);
        _checkCurrent(ticket);
        await _refreshInventory(ticket);
        if (_downloadedIds.contains(id)) {
          throw const AiServiceException(
            'removalFailed',
            'The model is still in storage. Please try removing it again.',
          );
        }
        if (_preferredProvider == 'local:$id') await setPreferredProvider(null);
      } catch (_) {
        if (_current(ticket)) await _tryRefreshInventory(ticket);
        rethrow;
      }
    });
  }

  bool _validPreference(Object? value) =>
      value == null ||
      value == 'apple' ||
      value == 'guided' ||
      models.any((model) => value == 'local:${model.id}');

  Future<void> setPreferredProvider(String? value) async {
    await initialize();
    _checkAlive();
    if (!_validPreference(value)) {
      throw const AiServiceException(
        'unknownProvider',
        'Choose an available conversation provider.',
      );
    }
    final write = _preferenceTail.then((_) async {
      _checkAlive();
      final saved = value == null
          ? await _preferences!.remove(preferencesKey)
          : await _preferences!.setString(
              preferencesKey,
              jsonEncode({'version': 1, 'preferredProvider': value}),
            );
      _checkAlive();
      if (!saved) {
        throw const AiServiceException(
          'storage',
          'Your provider preference could not be saved. Please retry.',
        );
      }
      _preferredProvider = value;
      _notify();
    });
    _preferenceTail = write.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    await write;
  }

  Future<T> _run<T>(
    LocalModelPhase phase,
    String? id,
    Future<T> Function(int ticket) action, {
    bool interrupt = false,
  }) async {
    _checkAlive();
    if (!interrupt) _checkIdle();
    final ticket = ++_epoch;
    _phase = phase;
    _workingModelId = id;
    if (phase != LocalModelPhase.cancelling) _progress = null;
    _error = null;
    _errorCode = null;
    _notify();
    try {
      final result = await action(ticket);
      _checkCurrent(ticket);
      _phase = _loadedModelId == null
          ? LocalModelPhase.idle
          : LocalModelPhase.ready;
      return result;
    } catch (cause) {
      if (!_current(ticket)) throw _cancelled;
      final failure = cause is AiServiceException
          ? cause
          : const AiServiceException(
              'localModelFailed',
              'The local model operation could not finish. Please retry or use guided rehearsal.',
            );
      if (failure.code == 'cancelled') {
        _phase = _loadedModelId == null
            ? LocalModelPhase.idle
            : LocalModelPhase.ready;
      } else {
        _phase = LocalModelPhase.error;
        _error = failure.message;
        _errorCode = failure.code;
      }
      throw failure;
    } finally {
      if (_current(ticket)) {
        _workingModelId = null;
        _progress = null;
        _notify();
      }
    }
  }

  Future<void> _tryRefreshInventory(int ticket) async {
    try {
      await _refreshInventory(ticket);
    } catch (_) {
      // When storage cannot be inspected, do not advertise unverified files.
      if (_current(ticket)) _downloadedIds = {};
    }
  }

  Future<void> _quietUnload() async {
    try {
      await _backend.unload();
    } catch (_) {}
  }

  LocalModelSpec _model(String id) {
    _checkAlive();
    for (final model in models) {
      if (model.id == id) return model;
    }
    throw const AiServiceException('unknownModel', 'Choose a listed model.');
  }

  void _requireSupport() {
    if (_support?.available != true) {
      throw AiServiceException(
        'unavailable',
        _support?.reason ?? 'Local models are unavailable.',
      );
    }
  }

  static const _cancelled = AiServiceException(
    'cancelled',
    'The local model operation was cancelled.',
  );
  bool _current(int ticket) => !_disposed && ticket == _epoch;
  void _checkCurrent(int ticket) {
    if (!_current(ticket)) throw _cancelled;
  }

  void _checkAlive() {
    if (_disposed) {
      throw const AiServiceException(
        'disposed',
        'The local model manager was closed.',
      );
    }
  }

  void _checkIdle() {
    _checkAlive();
    if (isBusy) {
      throw const AiServiceException(
        'busy',
        'Wait for the current local model operation to finish.',
      );
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    ++_epoch;
    _loadedModelId = null;
    _workingModelId = null;
    _progress = null;
    _phase = LocalModelPhase.idle;
    // ChangeNotifier disposal is synchronous. Shutdown remains awaitable, and
    // invalidating first prevents every late callback from touching the UI.
    _shutdown = () async {
      try {
        await _backend.cancelDownload();
      } catch (_) {}
      await _quietUnload();
      try {
        await _backend.dispose();
      } catch (_) {}
    }();
    super.dispose();
  }
}
