import 'package:flutter/foundation.dart';

import '../data/day_clock.dart';
import '../data/economy.dart';
import '../data/shop_items.dart';
import '../data/storage.dart';
import '../data/tag_palette.dart';
import '../data/title_repository.dart';
import '../models/completion_record.dart';
import '../models/reward_record.dart';
import '../models/routine.dart';
import '../models/tag.dart';
import '../models/title_def.dart';
import '../models/todo.dart';

/// Result of toggling a routine/todo to complete (or uncomplete).
enum CompleteOutcome {
  none,
  rewarded,
  alreadyRewarded,
}

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final AppStorage _storage;

  List<Routine> routines = [];
  List<Todo> todos = [];
  List<Tag> tags = [];
  List<CompletionRecord> completionLog = [];
  List<RewardRecord> rewardLog = [];
  int gold = 0;
  int unspentPoints = 0;
  Set<String> ownedItemIds = {};
  /// Category name → equipped item id.
  Map<String, String> equipped = {};
  List<TitleDef> titles = [];
  Set<String> ownedTitleIds = {};
  String? equippedTitleId;

  static const String centerTitleId = 'me';

  Future<void> load() async {
    gold = await _storage.loadGold();
    completionLog = await _storage.loadCompletionLog();
    rewardLog = await _storage.loadRewardLog();
    unspentPoints = await _storage.loadPoints();
    ownedItemIds = await _storage.loadOwnedItems();
    equipped = await _storage.loadEquipped();
    titles = await TitleRepository.load();
    final validIds = titles.map((t) => t.id).toSet();
    final savedOwned = await _storage.loadOwnedTitles();
    ownedTitleIds = {
      centerTitleId,
      ...savedOwned.where(validIds.contains),
    };
    final savedEquipped = await _storage.loadEquippedTitle();
    equippedTitleId =
        savedEquipped != null && ownedTitleIds.contains(savedEquipped)
            ? savedEquipped
            : null;

    tags = await _storage.loadTags();
    var tagsDirty = false;
    if (tags.isEmpty) {
      tags = TagPresets.createDefaults();
      tagsDirty = true;
    }

    // Migrate legacy custom_tags_v1 string list into main tags.
    final legacyCustom = await _storage.loadCustomTags();
    for (final name in legacyCustom) {
      final trimmed = name.trim();
      if (trimmed.isEmpty) continue;
      if (_findTagIdByRef(trimmed) != null) continue;
      tags = [
        ...tags,
        Tag(
          id: _newTagId(),
          name: trimmed,
          colorValue: kTagPaletteColors[
              tags.length % kTagPaletteColors.length],
        ),
      ];
      tagsDirty = true;
    }

    routines = await _storage.loadRoutines();
    todos = await _storage.loadTodos();
    final routinesMigrated = _migrateItemTagIds(routines.map((r) => r.tagIds));
    final todosMigrated = _migrateItemTagIds(todos.map((t) => t.tagIds));
    var itemsDirty = false;
    if (routinesMigrated.dirty) {
      routines = [
        for (var i = 0; i < routines.length; i++)
          routines[i].copyWith(tagIds: routinesMigrated.ids[i]),
      ];
      itemsDirty = true;
    }
    if (todosMigrated.dirty) {
      todos = [
        for (var i = 0; i < todos.length; i++)
          todos[i].copyWith(tagIds: todosMigrated.ids[i]),
      ];
      itemsDirty = true;
    }
    if (routinesMigrated.tagsDirty || todosMigrated.tagsDirty) {
      tagsDirty = true;
    }

    await Future.wait([
      _storage.saveOwnedTitles(ownedTitleIds),
      _storage.saveEquippedTitle(equippedTitleId),
      if (tagsDirty) _storage.saveTags(tags),
      if (itemsDirty) _storage.saveRoutines(routines),
      if (itemsDirty) _storage.saveTodos(todos),
    ]);
    notifyListeners();
  }

  int _tagIdSeq = 0;

  String _newTagId() {
    _tagIdSeq += 1;
    return 'tag_${DateTime.now().microsecondsSinceEpoch}_$_tagIdSeq';
  }

  Tag? tagById(String id) {
    for (final tag in tags) {
      if (tag.id == id) return tag;
    }
    return null;
  }

  List<Tag> get mainTags => tags.where((t) => t.isMain).toList();

  List<Tag> subTagsOf(String parentId) =>
      tags.where((t) => t.parentId == parentId).toList();

  /// Resolves a stored ref (id or legacy name) to an existing tag id, if any.
  String? _findTagIdByRef(String ref) {
    if (tags.any((t) => t.id == ref)) return ref;
    for (final tag in tags) {
      if (tag.name == ref) return tag.id;
    }
    for (final presetId in TagPresets.ids) {
      if (ref == presetId) return presetId;
      if (TagPresets.knownNamesFor(presetId).contains(ref)) return presetId;
    }
    return null;
  }

  String _resolveOrCreateTagRef(String ref) {
    final existing = _findTagIdByRef(ref);
    if (existing != null) return existing;
    final created = Tag(
      id: _newTagId(),
      name: ref,
      colorValue:
          kTagPaletteColors[tags.length % kTagPaletteColors.length],
    );
    tags = [...tags, created];
    return created.id;
  }

  ({List<List<String>> ids, bool dirty, bool tagsDirty}) _migrateItemTagIds(
    Iterable<List<String>> source,
  ) {
    final result = <List<String>>[];
    var dirty = false;
    final tagsBefore = tags.length;
    for (final refs in source) {
      final next = refs.map(_resolveOrCreateTagRef).toList();
      if (!listEquals(next, refs)) dirty = true;
      result.add(next);
    }
    return (
      ids: result,
      dirty: dirty,
      tagsDirty: tags.length != tagsBefore,
    );
  }

  Future<Tag> addTag({
    required String name,
    required int colorValue,
    String? parentId,
  }) async {
    final trimmed = name.trim();
    final tag = Tag(
      id: _newTagId(),
      name: trimmed,
      colorValue: colorValue,
      parentId: parentId,
    );
    tags = [...tags, tag];
    notifyListeners();
    await _storage.saveTags(tags);
    return tag;
  }

  Future<void> deleteTag(String id) async {
    final toRemove = <String>{id};
    for (final tag in tags) {
      if (tag.parentId == id) toRemove.add(tag.id);
    }
    tags = tags.where((t) => !toRemove.contains(t.id)).toList();
    routines = [
      for (final r in routines)
        r.copyWith(
          tagIds: r.tagIds.where((tid) => !toRemove.contains(tid)).toList(),
        ),
    ];
    todos = [
      for (final t in todos)
        t.copyWith(
          tagIds: t.tagIds.where((tid) => !toRemove.contains(tid)).toList(),
        ),
    ];
    notifyListeners();
    await Future.wait([
      _storage.saveTags(tags),
      _storage.saveRoutines(routines),
      _storage.saveTodos(todos),
    ]);
  }

  TitleDef? titleById(String id) {
    for (final title in titles) {
      if (title.id == id) return title;
    }
    return null;
  }

  bool ownsTitle(String id) => ownedTitleIds.contains(id);

  /// True when at least one neighbor title is already owned.
  bool isTitleReachable(TitleDef title) {
    if (ownedTitleIds.contains(title.id)) return true;
    return title.neighbors.any(ownedTitleIds.contains);
  }

  bool canAffordTitle(TitleDef title) => unspentPoints >= title.cost;

  /// Buys a reachable title with unspent points. Owned titles stay owned.
  Future<bool> buyTitle(String id) async {
    final title = titleById(id);
    if (title == null) return false;
    if (ownedTitleIds.contains(id)) return false;
    if (!isTitleReachable(title)) return false;
    if (!canAffordTitle(title)) return false;

    unspentPoints -= title.cost;
    _clampPoints();
    ownedTitleIds = {...ownedTitleIds, id};
    notifyListeners();
    await _persist();
    return true;
  }

  Future<void> equipTitle(String id) async {
    if (!ownedTitleIds.contains(id)) return;
    if (equippedTitleId == id) {
      equippedTitleId = null;
    } else {
      equippedTitleId = id;
    }
    notifyListeners();
    await _persist();
  }

  /// Dominant direction by owned title count; null means balanced / none.
  TitleDirection? dominantTendency() {
    final counts = <TitleDirection, int>{
      TitleDirection.extro: 0,
      TitleDirection.creative: 0,
      TitleDirection.intro: 0,
      TitleDirection.logic: 0,
    };
    for (final id in ownedTitleIds) {
      final title = titleById(id);
      if (title == null) continue;
      if (!counts.containsKey(title.direction)) continue;
      counts[title.direction] = counts[title.direction]! + 1;
    }
    var best = 0;
    for (final count in counts.values) {
      if (count > best) best = count;
    }
    if (best == 0) return null;
    final leaders = counts.entries.where((e) => e.value == best).toList();
    if (leaders.length != 1) return null;
    return leaders.first.key;
  }

  bool ownsItem(String id) => ownedItemIds.contains(id);

  String? equippedId(ShopCategory category) => equipped[category.name];

  bool isEquipped(String id) {
    final item = ShopCatalog.byId(id);
    if (item == null) return false;
    return equipped[item.category.name] == id;
  }

  /// Deducts gold and adds to owned. Returns false if not enough gold or already owned.
  Future<bool> buyItem(String id) async {
    final item = ShopCatalog.byId(id);
    if (item == null) return false;
    if (ownedItemIds.contains(id)) return false;
    if (gold < item.price) return false;

    gold -= item.price;
    _clampGold();
    ownedItemIds = {...ownedItemIds, id};
    notifyListeners();
    await _persist();
    return true;
  }

  /// Equips [id] in its category (one slot per category).
  Future<void> equipItem(String id) async {
    final item = ShopCatalog.byId(id);
    if (item == null) return;
    if (!ownedItemIds.contains(id)) return;

    equipped = {...equipped, item.category.name: id};
    notifyListeners();
    await _persist();
  }

  Future<void> unequip(ShopCategory category) async {
    if (!equipped.containsKey(category.name)) return;
    equipped = Map<String, String>.from(equipped)..remove(category.name);
    notifyListeners();
    await _persist();
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

  /// Outcome when the item just became complete (for SnackBar).
  Future<CompleteOutcome> toggleRoutineChecklistItem(
    String id,
    int itemIndex,
  ) async {
    final index = routines.indexWhere((r) => r.id == id);
    if (index < 0) return CompleteOutcome.none;

    final routine = routines[index];
    if (itemIndex < 0 || itemIndex >= routine.checklist.length) {
      return CompleteOutcome.none;
    }

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
      return toggleRoutineDone(id);
    }
    if (!allChecked && wasComplete) {
      await toggleRoutineDone(id);
      return CompleteOutcome.none;
    }

    notifyListeners();
    await _persist();
    return CompleteOutcome.none;
  }

  /// Outcome when the item just became complete (for SnackBar).
  Future<CompleteOutcome> toggleTodoChecklistItem(
    String id,
    int itemIndex,
  ) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index < 0) return CompleteOutcome.none;

    final todo = todos[index];
    if (itemIndex < 0 || itemIndex >= todo.checklist.length) {
      return CompleteOutcome.none;
    }

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
      return toggleTodoDone(id);
    }
    if (!allChecked && wasComplete) {
      await toggleTodoDone(id);
      return CompleteOutcome.none;
    }

    notifyListeners();
    await _persist();
    return CompleteOutcome.none;
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

  bool _hasRewardFor(String itemId, String dateKey) {
    return rewardLog.any((r) => r.itemId == itemId && r.dateKey == dateKey);
  }

  void _addReward(String itemId, String dateKey) {
    if (_hasRewardFor(itemId, dateKey)) return;
    rewardLog = [
      ...rewardLog,
      RewardRecord(itemId: itemId, dateKey: dateKey),
    ];
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
      _storage.saveTags(tags),
      _storage.saveGold(gold),
      _storage.saveCompletionLog(completionLog),
      _storage.saveRewardLog(rewardLog),
      _storage.savePoints(unspentPoints),
      _storage.saveOwnedItems(ownedItemIds),
      _storage.saveEquipped(equipped),
      _storage.saveOwnedTitles(ownedTitleIds),
      _storage.saveEquippedTitle(equippedTitleId),
    ]);
  }

  Future<CompleteOutcome> toggleRoutineDone(String id) async {
    final index = routines.indexWhere((r) => r.id == id);
    if (index < 0) return CompleteOutcome.none;

    final routine = routines[index];
    final done = isRoutineDoneToday(routine);
    final today = DayClock.todayKey();

    if (done) {
      // Uncheck: drop completion only — keep gold/points/rewardLog.
      _removeCompletionRecord(routine.id, today);
      routines[index] = routine.copyWith(clearLastDoneDate: true);
      notifyListeners();
      await _persist();
      return CompleteOutcome.none;
    }

    final alreadyRewarded = _hasRewardFor(routine.id, today);
    if (!alreadyRewarded) {
      gold += Economy.routineCompleteGold;
      unspentPoints += Economy.completePoint;
      _addReward(routine.id, today);
    }
    _addCompletionRecord(
      type: 'routine',
      itemId: routine.id,
      title: routine.title,
      tags: routine.tagIds,
    );
    routines[index] = routine.copyWith(lastDoneDate: today);
    notifyListeners();
    await _persist();
    return alreadyRewarded
        ? CompleteOutcome.alreadyRewarded
        : CompleteOutcome.rewarded;
  }

  Future<CompleteOutcome> toggleTodoDone(String id) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index < 0) return CompleteOutcome.none;

    final todo = todos[index];
    final today = DayClock.todayKey();

    if (todo.done) {
      // Uncheck: drop completion only — keep gold/points/rewardLog.
      _removeCompletionRecord(todo.id, today);
      todos[index] = todo.copyWith(done: false, clearDoneDate: true);
      notifyListeners();
      await _persist();
      return CompleteOutcome.none;
    }

    final alreadyRewarded = _hasRewardFor(todo.id, today);
    if (!alreadyRewarded) {
      gold += Economy.todoCompleteGold;
      unspentPoints += Economy.completePoint;
      _addReward(todo.id, today);
    }
    _addCompletionRecord(
      type: 'todo',
      itemId: todo.id,
      title: todo.title,
      tags: todo.tagIds,
    );
    todos[index] = todo.copyWith(
      done: true,
      doneDate: today,
    );
    notifyListeners();
    await _persist();
    return alreadyRewarded
        ? CompleteOutcome.alreadyRewarded
        : CompleteOutcome.rewarded;
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

}
