import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum AiStatus {
  available,
  unsupportedPlatform,
  unsupportedOS,
  deviceNotEligible,
  appleIntelligenceNotEnabled,
  modelNotReady,
  unavailable,
}

class AiAvailability {
  const AiAvailability({required this.status, required this.reason});

  final AiStatus status;
  final String reason;
  bool get isAvailable => status == AiStatus.available;
  bool get supported =>
      status != AiStatus.unsupportedPlatform &&
      status != AiStatus.unsupportedOS &&
      status != AiStatus.deviceNotEligible;

  factory AiAvailability.fromMap(Map<Object?, Object?> map) {
    final status = AiStatus.values.firstWhere(
      (value) => value.name == map['status'],
      orElse: () => AiStatus.unavailable,
    );
    return AiAvailability(
      status: status,
      reason: map['reason'] is String
          ? map['reason']! as String
          : 'Apple Intelligence is unavailable. Guided scenarios are still available.',
    );
  }
}

class ConversationMessage {
  const ConversationMessage({required this.role, required this.content});

  /// Only `user` and `assistant` are accepted; no client-supplied instructions.
  final String role;
  final String content;

  Map<String, String> toMap() => {'role': role, 'content': content};
}

class ConversationTurn {
  const ConversationTurn({
    required this.reply,
    required this.suggestedReply,
    required this.practiceGoal,
    required this.followUpQuestion,
  });

  final String reply;
  final String suggestedReply;
  final String practiceGoal;
  final String followUpQuestion;

  factory ConversationTurn.fromMap(Map<Object?, Object?> map) {
    String field(String name) {
      final value = map[name];
      if (value is! String || value.trim().isEmpty || value.length > 2000) {
        throw const AiServiceException(
          'invalidResponse',
          'The local model returned an incomplete response. Please try again.',
        );
      }
      return value.trim();
    }

    final turn = ConversationTurn(
      reply: field('reply'),
      suggestedReply: field('suggestedReply'),
      practiceGoal: field('practiceGoal'),
      followUpQuestion: field('followUpQuestion'),
    );
    final words = [
      turn.reply,
      turn.suggestedReply,
      turn.practiceGoal,
      turn.followUpQuestion,
    ].join(' ').split(RegExp(r'\s+')).length;
    if (words > 200) {
      throw const AiServiceException(
        'invalidResponse',
        'The local model’s response was too long. Please try again.',
      );
    }
    return turn;
  }
}

class AiServiceException implements Exception {
  const AiServiceException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

/// Uses Apple's on-device text model only. No network or camera API is involved.
/// Keep an instance per conversation UI, and reset when starting over or leaving.
class AppleIntelligenceService {
  AppleIntelligenceService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('nohasl/apple_intelligence');

  final MethodChannel _channel;
  int _generation = 0;
  bool _responding = false;
  Future<void>? _resetting;

  bool get _applePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  Future<AiAvailability> availability() async {
    if (!_applePlatform) {
      return const AiAvailability(
        status: AiStatus.unsupportedPlatform,
        reason:
            'On-device Apple Intelligence requires a supported iPhone, iPad, '
            'or Mac. Guided conversations work on this platform.',
      );
    }
    try {
      final map = await _channel.invokeMapMethod<Object?, Object?>(
        'availability',
      );
      return AiAvailability.fromMap(map ?? const {});
    } on MissingPluginException {
      return const AiAvailability(
        status: AiStatus.unavailable,
        reason:
            'This build does not include Apple Intelligence. Guided '
            'conversations are still available.',
      );
    } on PlatformException {
      return const AiAvailability(
        status: AiStatus.unavailable,
        reason:
            'Apple Intelligence could not be checked. Try again in a moment.',
      );
    }
  }

  Future<ConversationTurn> respond({
    required String topic,
    required String level,
    required String message,
    required List<ConversationMessage> history,
  }) async {
    if (!_applePlatform) {
      throw const AiServiceException(
        'unsupportedPlatform',
        'On-device Apple Intelligence is unavailable on this platform.',
      );
    }
    if (_responding || _resetting != null) {
      throw const AiServiceException(
        'busy',
        'Please wait for the current response to finish.',
      );
    }
    final text = message.trim();
    if (text.isEmpty ||
        text.length > 1000 ||
        topic.trim().isEmpty ||
        topic.length > 120 ||
        level.trim().isEmpty ||
        level.length > 40) {
      throw const AiServiceException(
        'invalidInput',
        'Use a topic up to 120 characters and a message from 1 to 1,000 characters.',
      );
    }
    final recent = history
        .where(
          (entry) =>
              (entry.role == 'user' || entry.role == 'assistant') &&
              entry.content.trim().isNotEmpty,
        )
        .toList();
    final bounded = recent
        .skip(recent.length > 6 ? recent.length - 6 : 0)
        .map(
          (entry) => {'role': entry.role, 'content': _clip(entry.content, 500)},
        )
        .toList();
    final generation = ++_generation;
    _responding = true;
    try {
      final map = await _channel
          .invokeMapMethod<Object?, Object?>('respond', {
            'topic': topic.trim(),
            'level': level.trim(),
            'message': text,
            'history': bounded,
          })
          .timeout(const Duration(seconds: 65));
      if (generation != _generation) {
        throw const AiServiceException(
          'cancelled',
          'Conversation request canceled.',
        );
      }
      return ConversationTurn.fromMap(map ?? const {});
    } on TimeoutException {
      await reset();
      throw const AiServiceException(
        'timeout',
        'The local model took too long. Please try again or use a guided scenario.',
      );
    } on MissingPluginException {
      throw const AiServiceException(
        'unavailable',
        'This build does not include the Apple Intelligence integration.',
      );
    } on PlatformException catch (error) {
      throw AiServiceException(
        error.code,
        error.message ?? 'The local model could not respond. Please try again.',
      );
    } finally {
      if (generation == _generation) _responding = false;
    }
  }

  /// Cancels pending output and discards native session context. It never clears
  /// learning progress; conversation text is not persisted by this service.
  Future<void> reset() async {
    if (_resetting case final reset?) return reset;
    _generation++;
    _responding = false;
    if (!_applePlatform) return;
    final task = _resetNative();
    _resetting = task;
    try {
      await task;
    } finally {
      _resetting = null;
    }
  }

  Future<void> _resetNative() async {
    try {
      await _channel.invokeMethod<void>('reset');
    } on MissingPluginException {
      /* No native state exists in this build. */
    } on PlatformException {
      /* Client generation still invalidates pending output. */
    }
  }

  static String _clip(String text, int length) {
    final runes = text.trim().runes;
    return String.fromCharCodes(runes.take(length));
  }
}
