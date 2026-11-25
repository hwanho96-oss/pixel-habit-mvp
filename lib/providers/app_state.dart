import 'package:flutter/foundation.dart';

import '../data/day_clock.dart';
import '../data/economy.dart';
import '../data/storage.dart';
import '../models/routine.dart';
import '../models/todo.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final AppStorage _storage;

  List<Routine> routines = [];
  List<Todo> todos = [];
  List<String> customTags = [];
  int gold = 0;

  Future<void> load() async {
    routines = await _storage.loadRoutines();
    todos = await _storage.loadTodos();
    gold = await _storage.loadGold();
    customTags = await _storage.loadCustomTags();
    notifyListeners();
  }

  /// Empty [repeatWeekdays] means every day. Future start dates are excluded.
  List<Routine> get todaysRoutines {
    final weekday = DayClock.logicalNow().weekday;
    return routines.where((r) {
      if (DayClock.isAfterToday(r.date)) return false;
      if (r.repeatWeekdays.isEmpty) return true;
      return r.repeatWeekdays.contains(weekday);
    }).toList();
  }

  /// Incomplete on/before today (carry-over), or completed today.
  List<Todo> get todaysTodos {
    final today = DayClock.todayKey();
    return todos.where((t) {
      if (t.doneDate == today) return true;
      if (!t.done && DayClock.isOnOrBeforeToday(t.date)) return true;
      return false;
    }).toList();
  }

  bool isRoutineDoneToday(Routine routine) =>
      routine.lastDoneDate == DayClock.todayKey();

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
      routines[index] =
          routine.copyWith(lastDoneDate: DayClock.todayKey());
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
      todos[index] = todo.copyWith(done: false, clearDoneDate: true);
    } else {
      gold += Economy.todoCompleteGold;
      todos[index] = todo.copyWith(
        done: true,
        doneDate: DayClock.todayKey(),
      );
    }

    notifyListeners();
    await _persist();
  }

  Future<void> addRoutine(Routine routine) async {
    routines = [...routines, routine];
    notifyListeners();
    await _persist();
  }

  Future<void> updateRoutine(Routine routine) async {
    final index = routines.indexWhere((r) => r.id == routine.id);
    if (index < 0) return;
    routines = [...routines];
    routines[index] = routine;
    notifyListeners();
    await _persist();
  }

  Future<void> addTodo(Todo todo) async {
    todos = [...todos, todo];
    notifyListeners();
    await _persist();
  }

  Future<void> updateTodo(Todo todo) async {
    final index = todos.indexWhere((t) => t.id == todo.id);
    if (index < 0) return;
    todos = [...todos];
    todos[index] = todo;
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

  Future<void> addCustomTag(String tag) async {
    final trimmed = tag.trim();
    if (trimmed.isEmpty || customTags.contains(trimmed)) return;
    customTags = [...customTags, trimmed];
    notifyListeners();
    await _storage.saveCustomTags(customTags);
  }
}
