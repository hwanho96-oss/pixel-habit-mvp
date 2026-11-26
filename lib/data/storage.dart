import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/completion_record.dart';
import '../models/routine.dart';
import '../models/todo.dart';

class AppStorage {
  static const _routinesKey = 'routines_v1';
  static const _todosKey = 'todos_v1';
  static const _goldKey = 'gold_v1';
  static const _customTagsKey = 'custom_tags_v1';
  static const _completionLogKey = 'completion_log_v1';
  static const _pointsKey = 'points_v1';
  static const _ownedItemsKey = 'owned_items_v1';
  static const _equippedKey = 'equipped_v1';

  Future<List<Routine>> loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_routinesKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Routine.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRoutines(List<Routine> routines) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(routines.map((e) => e.toJson()).toList());
    await prefs.setString(_routinesKey, encoded);
  }

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_todosKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(_todosKey, encoded);
  }

  Future<int> loadGold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_goldKey) ?? 0;
  }

  Future<void> saveGold(int gold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_goldKey, gold);
  }

  Future<List<String>> loadCustomTags() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customTagsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => e as String).toList();
  }

  Future<void> saveCustomTags(List<String> tags) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customTagsKey, jsonEncode(tags));
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
}
