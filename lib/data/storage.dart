import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/routine.dart';
import '../models/todo.dart';

class AppStorage {
  static const _routinesKey = 'routines_v1';
  static const _todosKey = 'todos_v1';
  static const _goldKey = 'gold_v1';

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
}
