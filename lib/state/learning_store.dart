import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/curriculum.dart';

class LearningStore extends ChangeNotifier {
  LearningStore(this.preferences) {
    _read();
  }
  final SharedPreferences preferences;
  final Set<String> completed = {};
  final Set<String> saved = {};
  final Map<String, int> activity = {};
  int dailyGoal = 10;
  bool sound = false;
  bool storageError = false;
  int get xp => allLessons
      .where((l) => completed.contains(l.id))
      .fold(0, (v, l) => v + l.xp);
  String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  int get todayMinutes => activity[dateKey(DateTime.now())] ?? 0;
  int get streak {
    var day = DateTime.now();
    if (!activity.containsKey(dateKey(day))) {
      day = day.subtract(const Duration(days: 1));
    }
    var result = 0;
    while (activity.containsKey(dateKey(day))) {
      result++;
      day = day.subtract(const Duration(days: 1));
    }
    return result;
  }

  Lesson get nextLesson => allLessons.firstWhere(
    (l) => !completed.contains(l.id),
    orElse: () => starterLesson,
  );
  void _read() {
    try {
      final data =
          jsonDecode(preferences.getString('nohasl.v1') ?? '{}')
              as Map<String, dynamic>;
      completed.addAll(
        (data['completed'] as List? ?? []).whereType<String>().where(
          (id) => allLessons.any((l) => l.id == id),
        ),
      );
      saved.addAll((data['saved'] as List? ?? []).whereType<String>());
      dailyGoal = [5, 10, 15, 20].contains(data['goal'])
          ? data['goal'] as int
          : 10;
      sound = data['sound'] == true;
      (data['activity'] as Map? ?? {}).forEach((k, v) {
        if (k is String && v is int && v > 0) activity[k] = v;
      });
    } catch (_) {
      storageError = true;
    }
  }

  Future<void> _save() async {
    notifyListeners();
    try {
      final stored = await preferences.setString(
        'nohasl.v1',
        jsonEncode({
          'completed': completed.toList(),
          'saved': saved.toList(),
          'goal': dailyGoal,
          'sound': sound,
          'activity': activity,
        }),
      );
      storageError = !stored;
    } catch (_) {
      storageError = true;
    }
    notifyListeners();
  }

  Future<void> complete(Lesson lesson, {required int activeSeconds}) async {
    completed.add(lesson.id);
    // Activity records time spent, never the advertised lesson duration.
    final minutes = (activeSeconds / 60).floor();
    if (minutes > 0) {
      final key = dateKey(DateTime.now());
      activity[key] = (activity[key] ?? 0) + minutes;
    }
    await _save();
  }

  Future<void> toggleSaved(String word) async {
    saved.contains(word) ? saved.remove(word) : saved.add(word);
    await _save();
  }

  Future<void> setGoal(int value) async {
    dailyGoal = value;
    await _save();
  }

  Future<void> setSound(bool value) async {
    sound = value;
    await _save();
  }

  Future<void> reset() async {
    completed.clear();
    saved.clear();
    activity.clear();
    await _save();
  }
}
