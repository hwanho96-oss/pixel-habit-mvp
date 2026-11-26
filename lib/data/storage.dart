import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/completion_record.dart';
import '../models/reward_record.dart';
import '../models/tag.dart';
import '../models/task.dart';

class AppStorage {
  static const _tasksKey = 'tasks_v1';
  static const _tasksMigratedKey = 'tasks_migrated_v1';
  // Legacy keys — kept for one-time migration; no longer written.
  static const _routinesKey = 'routines_v1';
  static const _todosKey = 'todos_v1';
  static const _goldKey = 'gold_v1';
  static const _customTagsKey = 'custom_tags_v1';
  static const _tagsKey = 'tags_v1';
  static const _completionLogKey = 'completion_log_v1';
  static const _pointsKey = 'points_v1';
  static const _ownedItemsKey = 'owned_items_v1';
  static const _equippedKey = 'equipped_v1';
  static const _rewardLogKey = 'reward_log_v1';
  static const _ownedTitlesKey = 'owned_titles_v1';
  static const _equippedTitleKey = 'equipped_title_v1';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final migrated = prefs.getBool(_tasksMigratedKey) ?? false;

    if (!migrated) {
      final tasks = await _migrateRoutinesAndTodos(prefs);
      await saveTasks(tasks);
      await prefs.setBool(_tasksMigratedKey, true);
      return tasks;
    }

    final raw = prefs.getString(_tasksKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_tasksKey, encoded);
  }

  Future<List<Task>> _migrateRoutinesAndTodos(SharedPreferences prefs) async {
    final tasks = <Task>[];

    final routinesRaw = prefs.getString(_routinesKey);
    if (routinesRaw != null) {
      final list = jsonDecode(routinesRaw) as List<dynamic>;
      for (final e in list) {
        tasks.add(Task.fromRoutineJson(e as Map<String, dynamic>));
      }
    }

    final todosRaw = prefs.getString(_todosKey);
    if (todosRaw != null) {
      final list = jsonDecode(todosRaw) as List<dynamic>;
      for (final e in list) {
        tasks.add(Task.fromTodoJson(e as Map<String, dynamic>));
      }
    }

    return tasks;
  }

  Future<int> loadGold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goldKey) ?? 0;
  }

  Future<void> saveGold(int gold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goldKey, gold);
  }

  /// Legacy string tags (pre tag model). Used once for migration.
  Future<List<String>> loadCustomTags() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customTagsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }

  Future<List<Tag>> loadTags() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_tagsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTags(List<Tag> tags) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(tags.map((e) => e.toJson()).toList());
    await prefs.setString(_tagsKey, encoded);
  }

  Future<List<CompletionRecord>> loadCompletionLog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_completionLogKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => CompletionRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCompletionLog(List<CompletionRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(records.map((e) => e.toJson()).toList());
    await prefs.setString(_completionLogKey, encoded);
  }

  Future<int> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pointsKey) ?? 0;
  }

  Future<void> savePoints(int points) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points);
  }

  Future<Set<String>> loadOwnedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ownedItemsKey);
    if (raw == null) return {};
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as String).toSet();
  }

  Future<void> saveOwnedItems(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ownedItemsKey, jsonEncode(ids.toList()));
  }

  /// Map of category name → item id.
  Future<Map<String, String>> loadEquipped() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_equippedKey);
    if (raw == null) return {};
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((k, v) => MapEntry(k, v as String));
  }

  Future<void> saveEquipped(Map<String, String> equipped) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_equippedKey, jsonEncode(equipped));
  }

  Future<List<RewardRecord>> loadRewardLog() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_rewardLogKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => RewardRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRewardLog(List<RewardRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(records.map((e) => e.toJson()).toList());
    await prefs.setString(_rewardLogKey, encoded);
  }

  Future<Set<String>> loadOwnedTitles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ownedTitlesKey);
    if (raw == null) return {};
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as String).toSet();
  }

  Future<void> saveOwnedTitles(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ownedTitlesKey, jsonEncode(ids.toList()));
  }

  Future<String?> loadEquippedTitle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_equippedTitleKey);
  }

  Future<void> saveEquippedTitle(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_equippedTitleKey);
    } else {
      await prefs.setString(_equippedTitleKey, id);
    }
  }
}
