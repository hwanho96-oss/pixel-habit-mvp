import 'package:flutter/foundation.dart';

import '../data/day_clock.dart';
import '../data/economy.dart';
import '../data/storage.dart';
import '../models/completion_record.dart';
import '../models/routine.dart';
import '../models/todo.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final AppStorage _storage;

  List<Routine> routines = [];
  List<Todo> todos = [];
  List<String> customTags = [];
  List<CompletionRecord> completionLog = [];
  int gold = 0;
  int unspentPoints = 0;

  Future<void> load() async {
    routines = await _storage.loadRoutines();
    todos = await _storage.loadTodos();
    gold = await _storage.loadGold();
    customTags = await _storage.loadCustomTags();
    completionLog = await _storage.loadCompletionLog();
    unspentPoints = await _storage.loadPoints();
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

  int get totalCompletions => completionLog.length;

  int get adventureDays =>
      completionLog.map((r) => r.dateKey).toSet().length;

  /// Latest dateKey in the log, or null if empty.
  String? get lastCheckDateKey {
    if (completionLog.isEmpty) return null;
    return completionLog
        .map((r) => r.dateKey)
        .reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
  }

  List<CompletionRecord> recordsInMonth(int year, int month) {
    final mm = month.toString().padLeft(2, '0');
    final prefix = '$year-$mm';
    return completionLog.where((r) => r.dateKey.startsWith(prefix)).toList();
  }

  List<CompletionRecord> recordsOnDay(String dateKey) {
    return completionLog.where((r) => r.dateKey == dateKey).toList();
  }

  void _clampGold() {
    if (gold < 0) gold = 0;
  }

  void _clampPoints() {
    if (unspentPoints < 0) unspentPoints = 0;
  }

  bool _hasRecordFor(String itemId, String dateKey) {
    return completionLog
        .any((r) => r.itemId == itemId && r.dateKey == dateKey);
  }

  void _addCompletionRecord({
    required String type,
    required String itemId,
    required String title,
    required List<String> tags,
  }) {
    final dateKey = DayClock.todayKey();
    if (_hasRecordFor(itemId, dateKey)) return;
    completionLog = [
      ...completionLog,
      CompletionRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: type,
        itemId: itemId,
        title: title,
        dateKey: dateKey,
        tags: List<String>.from(tags),
      ),
    ];
  }

  void _removeCompletionRecord(String itemId, String dateKey) {
    completionLog = completionLog
        .where((r) => !(r.itemId == itemId && r.dateKey == dateKey))
        .toList();
  }

  Future<void> _persist() async {
    await Future.wait([
      _storage.saveRoutines(routines),
      _storage.saveTodos(todos),
      _storage.saveGold(gold),
      _storage.saveCompletionLog(completionLog),
      _storage.savePoints(unspentPoints),
    ]);
  }

  Future<void> toggleRoutineDone(String id) async {
    final index = routines.indexWhere((r) => r.id == id);
    if (index < 0) return;

    final routine = routines[index];
    final done = isRoutineDoneToday(routine);
    final today = DayClock.todayKey();

    if (done) {
      gold -= Economy.routineCompleteGold;
      _clampGold();
      unspentPoints -= Economy.completePoint;
      _clampPoints();
      _removeCompletionRecord(routine.id, today);
      routines[index] = routine.copyWith(clearLastDoneDate: true);
    } else {
      gold += Economy.routineCompleteGold;
      unspentPoints += Economy.completePoint;
      _addCompletionRecord(
        type: 'routine',
        itemId: routine.id,
        title: routine.title,
        tags: routine.tags,
      );
      routines[index] =
          routine.copyWith(lastDoneDate: today);
    }

    notifyListeners();
    await _persist();
  }

  Future<void> toggleTodoDone(String id) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index < 0) return;

    final todo = todos[index];
    final today = DayClock.todayKey();

    if (todo.done) {
      gold -= Economy.todoCompleteGold;
      _clampGold();
      unspentPoints -= Economy.completePoint;
      _clampPoints();
      _removeCompletionRecord(todo.id, today);
      todos[index] = todo.copyWith(done: false, clearDoneDate: true);
    } else {
      gold += Economy.todoCompleteGold;
      unspentPoints += Economy.completePoint;
      _addCompletionRecord(
        type: 'todo',
        itemId: todo.id,
        title: todo.title,
        tags: todo.tags,
      );
      todos[index] = todo.copyWith(
        done: true,
        doneDate: today,
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
