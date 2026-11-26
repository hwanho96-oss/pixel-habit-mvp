import 'package:flutter/foundation.dart';

import '../data/day_clock.dart';
import '../data/economy.dart';
import '../data/goal_math.dart';
import '../data/shop_items.dart';
import '../data/storage.dart';
import '../data/tag_palette.dart';
import '../data/title_repository.dart';
import '../models/completion_record.dart';
import '../models/goal.dart';
import '../models/measure_kind.dart';
import '../models/reward_record.dart';
import '../models/tag.dart';
import '../models/task.dart';
import '../models/title_def.dart';

/// Result of toggling a task to complete (or uncomplete).
enum CompleteOutcome {
  none,
  rewarded,
  alreadyRewarded,
}

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final AppStorage _storage;

  List<Task> tasks = [];
  List<Tag> tags = [];
  List<CompletionRecord> completionLog = [];
  List<RewardRecord> rewardLog = [];
  List<Goal> goals = [];
  List<GoalLog> goalLogs = [];
  /// goalId → timer state (persisted across restarts).
  Map<String, GoalTimerState> goalTimers = {};
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

    tasks = await _storage.loadTasks();
    final tasksMigrated = _migrateItemTagIds(tasks.map((t) => t.tagIds));
    var itemsDirty = false;
    if (tasksMigrated.dirty) {
      tasks = [
        for (var i = 0; i < tasks.length; i++)
          tasks[i].copyWith(tagIds: tasksMigrated.ids[i]),
      ];
      itemsDirty = true;
    }
    if (tasksMigrated.tagsDirty) {
      tagsDirty = true;
    }

    goals = await _storage.loadGoals();
    goalLogs = await _storage.loadGoalLogs();
    final timers = await _storage.loadGoalTimers();
    goalTimers = {for (final t in timers) t.goalId: t};

    await Future.wait([
      _storage.saveOwnedTitles(ownedTitleIds),
      _storage.saveEquippedTitle(equippedTitleId),
      if (tagsDirty) _storage.saveTags(tags),
      if (itemsDirty) _storage.saveTasks(tasks),
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
    tasks = [
      for (final t in tasks)
        t.copyWith(
          tagIds: t.tagIds.where((tid) => !toRemove.contains(tid)).toList(),
        ),
    ];
    goals = [
      for (final g in goals)
        g.copyWith(
          tagIds: g.tagIds.where((tid) => !toRemove.contains(tid)).toList(),
        ),
    ];
    notifyListeners();
    await Future.wait([
      _storage.saveTags(tags),
      _storage.saveTasks(tasks),
      _storage.saveGoals(goals),
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

  /// Tasks visible on the home "할 일" list for the logical today.
  List<Task> get todaysTasks {
    final weekday = DayClock.logicalNow().weekday;
    final today = DayClock.todayKey();
    return tasks.where((t) {
      if (DayClock.isAfterToday(t.date)) return false;
      if (t.isRepeating) {
        return t.repeatWeekdays.contains(weekday);
      }
      if (t.doneDate == today) return true;
      if (!t.done && DayClock.isOnOrBeforeToday(t.date)) return true;
      return false;
    }).toList();
  }

  bool isTaskDoneToday(Task task) {
    if (task.isRepeating) {
      return task.lastDoneDate == DayClock.todayKey();
    }
    return task.done;
  }

  /// Repeating checklist resets each logical day via [Task.checklistDateKey].
  List<int> effectiveChecklistDone(Task task) {
    if (task.isRepeating) {
      if (task.checklistDateKey != DayClock.todayKey()) return const [];
      return _validChecklistDone(task.checklistDone, task.checklist.length);
    }
    return _validChecklistDone(task.checklistDone, task.checklist.length);
  }

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
  Future<CompleteOutcome> toggleChecklistItem(
    String id,
    int itemIndex,
  ) async {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index < 0) return CompleteOutcome.none;

    final task = tasks[index];
    if (itemIndex < 0 || itemIndex >= task.checklist.length) {
      return CompleteOutcome.none;
    }

    final today = DayClock.todayKey();
    final doneSet = effectiveChecklistDone(task).toSet();
    if (doneSet.contains(itemIndex)) {
      doneSet.remove(itemIndex);
    } else {
      doneSet.add(itemIndex);
    }
    final nextDone = doneSet.toList()..sort();
    final wasComplete = isTaskDoneToday(task);
    final allChecked = _isAllChecklistChecked(task.checklist, nextDone);

    if (task.isRepeating) {
      tasks[index] = task.copyWith(
        checklistDone: nextDone,
        checklistDateKey: today,
      );
    } else {
      tasks[index] = task.copyWith(checklistDone: nextDone);
    }

    if (allChecked && !wasComplete) {
      return toggleTaskDone(id);
    }
    if (!allChecked && wasComplete) {
      await toggleTaskDone(id);
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
    required String itemId,
    required String title,
    required List<String> tagIds,
  }) {
    final dateKey = DayClock.todayKey();
    if (_hasRecordFor(itemId, dateKey)) return;

    completionLog = [
      ...completionLog,
      CompletionRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: 'task',
        itemId: itemId,
        title: title,
        dateKey: dateKey,
        tagIds: List<String>.from(tagIds),
        amount: 1.0,
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
      _storage.saveTasks(tasks),
      _storage.saveTags(tags),
      _storage.saveGold(gold),
      _storage.saveCompletionLog(completionLog),
      _storage.saveRewardLog(rewardLog),
      _storage.savePoints(unspentPoints),
      _storage.saveOwnedItems(ownedItemIds),
      _storage.saveEquipped(equipped),
      _storage.saveOwnedTitles(ownedTitleIds),
      _storage.saveEquippedTitle(equippedTitleId),
      _storage.saveGoals(goals),
      _storage.saveGoalLogs(goalLogs),
      _storage.saveGoalTimers(goalTimers.values.toList()),
    ]);
  }

  Goal? goalById(String id) {
    for (final g in goals) {
      if (g.id == id) return g;
    }
    return null;
  }

  int goalValueOn(String goalId, String dateKey) {
    for (final log in goalLogs) {
      if (log.goalId == goalId && log.dateKey == dateKey) return log.value;
    }
    return 0;
  }

  int goalValueToday(String goalId) =>
      goalValueOn(goalId, DayClock.todayKey());

  int goalPeriodSum(Goal goal) {
    final keys = periodDateKeysFor(goal.period).toSet();
    var sum = 0;
    for (final log in goalLogs) {
      if (log.goalId == goal.id && keys.contains(log.dateKey)) {
        sum += log.value;
      }
    }
    return sum;
  }

  GoalTimerState? goalTimerOf(String goalId) => goalTimers[goalId];

  int goalTimerElapsedMs(String goalId) {
    final timer = goalTimers[goalId];
    if (timer == null) return 0;
    return timer.elapsedMs();
  }

  Future<void> addGoal(Goal goal) async {
    goals = [...goals, goal];
    notifyListeners();
    await _persist();
  }

  Future<void> updateGoal(Goal goal) async {
    final index = goals.indexWhere((g) => g.id == goal.id);
    if (index < 0) return;
    goals = [...goals];
    goals[index] = goal;
    notifyListeners();
    await _persist();
  }

  Future<void> deleteGoal(String id) async {
    goals = goals.where((g) => g.id != id).toList();
    goalLogs = goalLogs.where((l) => l.goalId != id).toList();
    goalTimers = Map<String, GoalTimerState>.from(goalTimers)..remove(id);
    notifyListeners();
    await _persist();
  }

  Future<void> _setGoalValueToday(String goalId, int value) async {
    final today = DayClock.todayKey();
    final next = value < 0 ? 0 : value;
    final index =
        goalLogs.indexWhere((l) => l.goalId == goalId && l.dateKey == today);
    if (next == 0) {
      if (index >= 0) {
        goalLogs = [...goalLogs]..removeAt(index);
      }
    } else if (index >= 0) {
      goalLogs = [...goalLogs];
      goalLogs[index] = goalLogs[index].copyWith(value: next);
    } else {
      goalLogs = [
        ...goalLogs,
        GoalLog(goalId: goalId, dateKey: today, value: next),
      ];
    }
    notifyListeners();
    await _persist();
  }

  /// Adjust today's amount log by [delta] (clamped at 0).
  Future<void> adjustGoalAmount(String goalId, int delta) async {
    final goal = goalById(goalId);
    if (goal == null || goal.kind != MeasureKind.amount) return;
    final current = goalValueToday(goalId);
    await _setGoalValueToday(goalId, current + delta);
  }

  Future<void> startGoalTimer(String goalId) async {
    final goal = goalById(goalId);
    if (goal == null || goal.kind != MeasureKind.time) return;
    final existing = goalTimers[goalId];
    if (existing?.isRunning == true) return;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    goalTimers = {
      ...goalTimers,
      goalId: GoalTimerState(
        goalId: goalId,
        accumulatedMs: existing?.accumulatedMs ?? 0,
        runningStartedAtMs: nowMs,
      ),
    };
    notifyListeners();
    await _persist();
  }

  Future<void> pauseGoalTimer(String goalId) async {
    final existing = goalTimers[goalId];
    if (existing == null || !existing.isRunning) return;
    goalTimers = {
      ...goalTimers,
      goalId: GoalTimerState(
        goalId: goalId,
        accumulatedMs: existing.elapsedMs(),
      ),
    };
    notifyListeners();
    await _persist();
  }

  /// Stops timer, adds elapsed minutes to today's log, resets timer.
  /// Returns minutes added (0 if none).
  Future<int> stopGoalTimer(String goalId) async {
    final goal = goalById(goalId);
    if (goal == null || goal.kind != MeasureKind.time) return 0;
    final existing = goalTimers[goalId];
    if (existing == null) return 0;
    final minutes = existing.elapsedMs() ~/ 60000;
    goalTimers = Map<String, GoalTimerState>.from(goalTimers)..remove(goalId);
    if (minutes > 0) {
      final current = goalValueToday(goalId);
      await _setGoalValueToday(goalId, current + minutes);
    } else {
      notifyListeners();
      await _persist();
    }
    return minutes;
  }

  Future<CompleteOutcome> toggleTaskDone(String id) async {
    final index = tasks.indexWhere((t) => t.id == id);
    if (index < 0) return CompleteOutcome.none;

    final task = tasks[index];
    final today = DayClock.todayKey();
    final done = isTaskDoneToday(task);

    if (done) {
      // Uncheck: drop completion only — keep gold/points/rewardLog.
      _removeCompletionRecord(task.id, today);
      if (task.isRepeating) {
        tasks[index] = task.copyWith(clearLastDoneDate: true);
      } else {
        tasks[index] = task.copyWith(done: false, clearDoneDate: true);
      }
      notifyListeners();
      await _persist();
      return CompleteOutcome.none;
    }

    final alreadyRewarded = _hasRewardFor(task.id, today);
    if (!alreadyRewarded) {
      gold += Economy.taskCompleteGold;
      unspentPoints += Economy.completePoint;
      _addReward(task.id, today);
    }
    _addCompletionRecord(
      itemId: task.id,
      title: task.title,
      tagIds: task.tagIds,
    );
    if (task.isRepeating) {
      tasks[index] = task.copyWith(lastDoneDate: today);
    } else {
      tasks[index] = task.copyWith(done: true, doneDate: today);
    }
    notifyListeners();
    await _persist();
    return alreadyRewarded
        ? CompleteOutcome.alreadyRewarded
        : CompleteOutcome.rewarded;
  }

  Future<void> addTask(Task task) async {
    tasks = [...tasks, task];
    notifyListeners();
    await _persist();
  }

  Future<void> updateTask(Task task) async {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index < 0) return;
    final previous = tasks[index];
    final remapped = remapChecklistDone(
      previousDone: previous.checklistDone,
      previousChecklist: previous.checklist,
      nextChecklist: task.checklist,
    );
    tasks = [...tasks];
    tasks[index] = task.copyWith(checklistDone: remapped);
    notifyListeners();
    await _persist();
  }

  Future<void> deleteTask(String id) async {
    tasks = tasks.where((t) => t.id != id).toList();
    notifyListeners();
    await _persist();
  }
}
