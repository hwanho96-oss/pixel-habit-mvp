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

  /// Routine checklist resets each logical day via [Routine.checklistDateKey].
  List<int> effectiveRoutineChecklistDone(Routine routine) {
    if (routine.checklistDateKey != DayClock.todayKey()) return const [];
    return _validChecklistDone(routine.checklistDone, routine.checklist.length);
  }

  List<int> effectiveTodoChecklistDone(Todo todo) =>
      _validChecklistDone(todo.checklistDone, todo.checklist.length);

  List<int> _validChecklistDone(List<int> done, int length) {
    return done.where((i) => i >= 0 && i < length).toList()..sort();
  }

  bool _isAllChecklistChecked(List<String> checklist, List<int> done) {
    if (checklist.isEmpty) return false;
    final set = done.toSet();
    return checklist.length == set.length &&
        List.generate(checklist.length, (i) => i).every(set.contains);
  }

  /// Keeps done indices aligned after checklist items are removed/added in the form.
  static List<int> remapChecklistDone({
    required List<int> previousDone,
    required List<String> previousChecklist,
    required List<String> nextChecklist,
  }) {
    if (previousChecklist.length == nextChecklist.length &&
        listEquals(previousChecklist, nextChecklist)) {
      return _clampDone(previousDone, nextChecklist.length);
    }

    // Prefer content-based remap when possible; fall back to index clamp.
    final nextDone = <int>[];
    for (final oldIndex in previousDone) {
      if (oldIndex < 0 || oldIndex >= previousChecklist.length) continue;
      final text = previousChecklist[oldIndex];
      final newIndex = nextChecklist.indexOf(text);
      if (newIndex >= 0 && !nextDone.contains(newIndex)) {
        nextDone.add(newIndex);
      }
    }
    nextDone.sort();
    return nextDone;
  }

  static List<int> _clampDone(List<int> done, int length) {
    return done.where((i) => i >= 0 && i < length).toList()..sort();
  }

  /// Returns true when the item just became complete (for praise SnackBar).
  Future<bool> toggleRoutineChecklistItem(String id, int itemIndex) async {
    final index = routines.indexWhere((r) => r.id == id);
    if (index < 0) return false;

    final routine = routines[index];
    if (itemIndex < 0 || itemIndex >= routine.checklist.length) return false;

    final today = DayClock.todayKey();
    final doneSet = effectiveRoutineChecklistDone(routine).toSet();
    if (doneSet.contains(itemIndex)) {
      doneSet.remove(itemIndex);
    } else {
      doneSet.add(itemIndex);
    }
    final nextDone = doneSet.toList()..sort();
    final wasComplete = isRoutineDoneToday(routine);
    final allChecked =
        _isAllChecklistChecked(routine.checklist, nextDone);

    routines[index] = routine.copyWith(
      checklistDone: nextDone,
      checklistDateKey: today,
    );

    if (allChecked && !wasComplete) {
      await toggleRoutineDone(id);
      return true;
    }
    if (!allChecked && wasComplete) {
      await toggleRoutineDone(id);
      return false;
    }

    notifyListeners();
    await _persist();
    return false;
  }

  /// Returns true when the item just became complete (for praise SnackBar).
  Future<bool> toggleTodoChecklistItem(String id, int itemIndex) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index < 0) return false;

    final todo = todos[index];
    if (itemIndex < 0 || itemIndex >= todo.checklist.length) return false;

    final doneSet = effectiveTodoChecklistDone(todo).toSet();
    if (doneSet.contains(itemIndex)) {
      doneSet.remove(itemIndex);
    } else {
      doneSet.add(itemIndex);
    }
    final nextDone = doneSet.toList()..sort();
    final wasComplete = todo.done;
    final allChecked = _isAllChecklistChecked(todo.checklist, nextDone);

    todos[index] = todo.copyWith(checklistDone: nextDone);

    if (allChecked && !wasComplete) {
      await toggleTodoDone(id);
      return true;
    }
    if (!allChecked && wasComplete) {
      await toggleTodoDone(id);
      return false;
    }

    notifyListeners();
    await _persist();
    return false;
  }

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
    final previous = routines[index];
    final remapped = remapChecklistDone(
      previousDone: previous.checklistDone,
      previousChecklist: previous.checklist,
      nextChecklist: routine.checklist,
    );
    routines = [...routines];
    routines[index] = routine.copyWith(checklistDone: remapped);
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
    final previous = todos[index];
    final remapped = remapChecklistDone(
      previousDone: previous.checklistDone,
      previousChecklist: previous.checklist,
      nextChecklist: todo.checklist,
    );
    todos = [...todos];
    todos[index] = todo.copyWith(checklistDone: remapped);
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
