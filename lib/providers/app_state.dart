import 'package:flutter/foundation.dart';

import '../data/economy.dart';
import '../data/storage.dart';
import '../models/routine.dart';
import '../models/todo.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final AppStorage _storage;

  List<Routine> routines = [];
  List<Todo> todos = [];
  int gold = 0;

  Future<void> load() async {
    routines = await _storage.loadRoutines();
    todos = await _storage.loadTodos();
    gold = await _storage.loadGold();
    notifyListeners();
  }

  String _todayKey([DateTime? now]) {
    final d = now ?? DateTime.now();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Empty [repeatWeekdays] means every day.
  List<Routine> get todaysRoutines {
    final today = DateTime.now();
    final weekday = today.weekday; // Mon=1 … Sun=7
    return routines.where((r) {
      if (r.repeatWeekdays.isEmpty) return true;
      return r.repeatWeekdays.contains(weekday);
    }).toList();
  }

  List<Todo> get todaysTodos {
    final today = DateTime.now();
    return todos.where((t) => _isSameDay(t.date, today)).toList();
  }

  bool isRoutineDoneToday(Routine routine) =>
      routine.lastDoneDate == _todayKey();

  void _clampGold() {
    if (gold < 0) gold = 0;
  }

  Future<void> _persist() async {
    await Future.wait([
      _storage.saveRoutines(routines),
      _storage.saveTodos(todos),
      _storage.saveGold(gold),
    ]);
  }

  Future<void> toggleRoutineDone(String id) async {
    final index = routines.indexWhere((r) => r.id == id);
    if (index < 0) return;

    final routine = routines[index];
    final done = isRoutineDoneToday(routine);

    if (done) {
      gold -= Economy.routineCompleteGold;
      _clampGold();
      routines[index] = routine.copyWith(clearLastDoneDate: true);
    } else {
      gold += Economy.routineCompleteGold;
      routines[index] = routine.copyWith(lastDoneDate: _todayKey());
    }

    notifyListeners();
    await _persist();
  }

  Future<void> toggleTodoDone(String id) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final todo = todos[index];
    if (todo.done) {
      gold -= Economy.todoCompleteGold;
      _clampGold();
      todos[index] = todo.copyWith(done: false);
    } else {
      gold += Economy.todoCompleteGold;
      todos[index] = todo.copyWith(done: true);
    }

    notifyListeners();
    await _persist();
  }

  Future<void> addRoutine(String title) async {
    final now = DateTime.now();
    routines = [
      ...routines,
      Routine(
        id: now.microsecondsSinceEpoch.toString(),
        title: title,
        checklist: const [],
        date: DateTime(now.year, now.month, now.day),
        repeatWeekdays: const [],
        tags: const [],
      ),
    ];
    notifyListeners();
    await _persist();
  }

  Future<void> addTodo(String title) async {
    final now = DateTime.now();
    todos = [
      ...todos,
      Todo(
        id: '${now.microsecondsSinceEpoch}_t',
        title: title,
        checklist: const [],
        date: DateTime(now.year, now.month, now.day),
        tags: const [],
        done: false,
      ),
    ];
    notifyListeners();
    await _persist();
  }

  Future<void> deleteRoutine(String id) async {
    routines = routines.where((r) => r.id != id).toList();
    notifyListeners();
    await _persist();
  }

  Future<void> deleteTodo(String id) async {
    todos = todos.where((t) => t.id != id).toList();
    notifyListeners();
    await _persist();
  }
}
