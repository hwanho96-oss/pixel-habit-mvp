import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/day_clock.dart';
import '../data/economy.dart';
import '../data/shop_items.dart';
import '../l10n/app_localizations.dart';
import '../models/routine.dart';
import '../models/todo.dart';
import '../providers/app_state.dart';
import '../ui/layout_config.dart';
import '../widgets/tag_chips.dart';
import 'routine_form_screen.dart';

enum _HomeSegment { routine, todo }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeSegment _segment = _HomeSegment.routine;
  final Set<String> _expandedIds = {};

  String? _formatTime(int? hour, int? minute) {
    if (hour == null || minute == null) return null;
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _toggleExpanded(String id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  Future<void> _confirmDelete({
    required VoidCallback onConfirm,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.deleteConfirmTitle),
          content: Text(l10n.deleteConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
    if (ok == true) onConfirm();
  }

  void _onFabPressed() {
    final type = _segment == _HomeSegment.routine
        ? FormItemType.routine
        : FormItemType.todo;
    context.push('/item/form', extra: ItemFormArgs(type: type));
  }

  bool _isAwayTwoOrMoreDays(String? lastCheckDateKey) {
    if (lastCheckDateKey == null) return false;
    final last = DateTime.tryParse(lastCheckDateKey);
    if (last == null) return false;
    final now = DayClock.logicalNow();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(last.year, last.month, last.day);
    return today.difference(lastDay).inDays >= 2;
  }

  void _showPraiseSnackBar({required bool welcomeBack, required int gold}) {
    final l10n = AppLocalizations.of(context)!;
    final points = Economy.completePoint;
    final message = welcomeBack
        ? l10n.praiseWelcomeBack(gold, points)
        : l10n.praiseChecked(gold, points);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showCompleteSnackBar({
    required CompleteOutcome outcome,
    required bool welcomeBack,
    required int gold,
  }) {
    if (outcome == CompleteOutcome.none) return;
    final l10n = AppLocalizations.of(context)!;
    if (outcome == CompleteOutcome.alreadyRewarded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.rewardAlreadyClaimed)),
      );
      return;
    }
    _showPraiseSnackBar(welcomeBack: welcomeBack, gold: gold);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final characterHeight =
                constraints.maxHeight * LayoutConfig.homeCharacterAreaRatio;

            return Column(
              children: [
                SizedBox(
                  height: characterHeight,
                  width: double.infinity,
                  child: _HomeCharacterArea(
                    goldLabel: l10n.goldAmount(state.gold),
                    adventureLabel:
                        l10n.adventureDaysCount(state.adventureDays),
                    equipped: state.equipped,
                    equippedTitleName: () {
                      final id = state.equippedTitleId;
                      if (id == null) return null;
                      final title = state.titleById(id);
                      if (title == null) return null;
                      return title.localizedName(
                        Localizations.localeOf(context).languageCode,
                      );
                    }(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SegmentedButton<_HomeSegment>(
                    segments: [
                      ButtonSegment(
                        value: _HomeSegment.routine,
                        label: Text(
                          l10n.segmentRoutine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      ButtonSegment(
                        value: _HomeSegment.todo,
                        label: Text(
                          l10n.segmentTodo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                    selected: {_segment},
                    onSelectionChanged: (next) {
                      setState(() => _segment = next.first);
                    },
                    showSelectedIcon: false,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _segment == _HomeSegment.routine
                      ? _RoutineList(
                          routines: state.todaysRoutines,
                          emptyHint: l10n.emptyRoutinesHint,
                          expandedIds: _expandedIds,
                          isDone: state.isRoutineDoneToday,
                          checklistDoneOf:
                              state.effectiveRoutineChecklistDone,
                          formatTime: _formatTime,
                          checklistProgress: l10n.checklistProgress,
                          onToggleExpand: _toggleExpanded,
                          onOpen: (routine) {
                            context.push(
                              '/item/form',
                              extra: ItemFormArgs(
                                type: FormItemType.routine,
                                routine: routine,
                              ),
                            );
                          },
                          onToggleDone: (routine, checked) async {
                            final welcomeBack =
                                _isAwayTwoOrMoreDays(state.lastCheckDateKey);
                            final outcome =
                                await state.toggleRoutineDone(routine.id);
                            if (!mounted) return;
                            if (checked) {
                              _showCompleteSnackBar(
                                outcome: outcome,
                                welcomeBack: welcomeBack,
                                gold: Economy.routineCompleteGold,
                              );
                            }
                          },
                          onToggleChecklist: (routine, itemIndex) async {
                            final welcomeBack =
                                _isAwayTwoOrMoreDays(state.lastCheckDateKey);
                            final outcome =
                                await state.toggleRoutineChecklistItem(
                              routine.id,
                              itemIndex,
                            );
                            if (!mounted) return;
                            _showCompleteSnackBar(
                              outcome: outcome,
                              welcomeBack: welcomeBack,
                              gold: Economy.routineCompleteGold,
                            );
                          },
                          onLongPress: (routine) {
                            _confirmDelete(
                              onConfirm: () =>
                                  state.deleteRoutine(routine.id),
                            );
                          },
                        )
                      : _TodoList(
                          todos: state.todaysTodos,
                          emptyHint: l10n.emptyTodosHint,
                          expandedIds: _expandedIds,
                          checklistDoneOf: state.effectiveTodoChecklistDone,
                          formatTime: _formatTime,
                          checklistProgress: l10n.checklistProgress,
                          onToggleExpand: _toggleExpanded,
                          onOpen: (todo) {
                            context.push(
                              '/item/form',
                              extra: ItemFormArgs(
                                type: FormItemType.todo,
                                todo: todo,
                              ),
                            );
                          },
                          onToggleDone: (todo, checked) async {
                            final welcomeBack =
                                _isAwayTwoOrMoreDays(state.lastCheckDateKey);
                            final outcome =
                                await state.toggleTodoDone(todo.id);
                            if (!mounted) return;
                            if (checked) {
                              _showCompleteSnackBar(
                                outcome: outcome,
                                welcomeBack: welcomeBack,
                                gold: Economy.todoCompleteGold,
                              );
                            }
                          },
                          onToggleChecklist: (todo, itemIndex) async {
                            final welcomeBack =
                                _isAwayTwoOrMoreDays(state.lastCheckDateKey);
                            final outcome =
                                await state.toggleTodoChecklistItem(
                              todo.id,
                              itemIndex,
                            );
                            if (!mounted) return;
                            _showCompleteSnackBar(
                              outcome: outcome,
                              welcomeBack: welcomeBack,
                              gold: Economy.todoCompleteGold,
                            );
                          },
                          onLongPress: (todo) {
                            _confirmDelete(
                              onConfirm: () => state.deleteTodo(todo.id),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _HomeCharacterArea extends StatelessWidget {
  const _HomeCharacterArea({
    required this.goldLabel,
    required this.adventureLabel,
    required this.equipped,
    required this.equippedTitleName,
  });

  final String goldLabel;
  final String adventureLabel;
  final Map<String, String> equipped;
  final String? equippedTitleName;

  String? _labelFor(AppLocalizations l10n, ShopCategory category) {
    final id = equipped[category.name];
    if (id == null) return null;
    final item = ShopCatalog.byId(id);
    if (item == null) return null;
    return ShopCatalog.itemName(l10n, item.nameKey);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bgId = equipped[ShopCategory.background.name];
    final bgColor = ShopCatalog.backgroundColor(bgId) ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    final top = _labelFor(l10n, ShopCategory.top);
    final bottom = _labelFor(l10n, ShopCategory.bottom);
    final weapon = _labelFor(l10n, ShopCategory.weapon);
    final pet = _labelFor(l10n, ShopCategory.pet);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: bgColor),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              if (equippedTitleName != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    equippedTitleName!,
                    style: Theme.of(context).textTheme.labelMedium,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
        Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              if (top != null) _EquipLabel(text: top),
              if (bottom != null) _EquipLabel(text: bottom),
              if (weapon != null) _EquipLabel(text: weapon),
              if (pet != null) _EquipLabel(text: pet),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 12,
          left: 12,
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  goldLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
                Text(
                  adventureLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EquipLabel extends StatelessWidget {
  const _EquipLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall,
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}

class _RoutineList extends StatelessWidget {
  const _RoutineList({
    required this.routines,
    required this.emptyHint,
    required this.expandedIds,
    required this.isDone,
    required this.checklistDoneOf,
    required this.formatTime,
    required this.checklistProgress,
    required this.onToggleExpand,
    required this.onOpen,
    required this.onToggleDone,
    required this.onToggleChecklist,
    required this.onLongPress,
  });

  final List<Routine> routines;
  final String emptyHint;
  final Set<String> expandedIds;
  final bool Function(Routine) isDone;
  final List<int> Function(Routine) checklistDoneOf;
  final String? Function(int?, int?) formatTime;
  final String Function(int done, int total) checklistProgress;
  final void Function(String id) onToggleExpand;
  final void Function(Routine routine) onOpen;
  final void Function(Routine routine, bool checked) onToggleDone;
  final void Function(Routine routine, int itemIndex) onToggleChecklist;
  final void Function(Routine routine) onLongPress;

  @override
  Widget build(BuildContext context) {
    if (routines.isEmpty) {
      return _EmptyHint(text: emptyHint);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: routines.length,
      itemBuilder: (context, index) {
        final routine = routines[index];
        final done = isDone(routine);
        final doneIndexes = checklistDoneOf(routine);
        final hasChecklist = routine.checklist.isNotEmpty;
        final expanded = expandedIds.contains(routine.id);
        final time = formatTime(routine.hour, routine.minute);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: done,
                    onChanged: hasChecklist
                        ? null
                        : (value) => onToggleDone(routine, value ?? false),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: hasChecklist
                          ? () => onToggleExpand(routine.id)
                          : () => onOpen(routine),
                      onLongPress: () => onLongPress(routine),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.title,
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasChecklist)
                              Text(
                                checklistProgress(
                                  doneIndexes.length,
                                  routine.checklist.length,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (time != null)
                              Text(
                                time,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            TagChipsRow(tagIds: routine.tagIds),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (hasChecklist) ...[
                    IconButton(
                      onPressed: () => onOpen(routine),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () => onToggleExpand(routine.id),
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ),
                  ],
                ],
              ),
              if (hasChecklist && expanded)
                _ChecklistItems(
                  items: routine.checklist,
                  doneIndexes: doneIndexes,
                  onToggle: (itemIndex) =>
                      onToggleChecklist(routine, itemIndex),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    required this.todos,
    required this.emptyHint,
    required this.expandedIds,
    required this.checklistDoneOf,
    required this.formatTime,
    required this.checklistProgress,
    required this.onToggleExpand,
    required this.onOpen,
    required this.onToggleDone,
    required this.onToggleChecklist,
    required this.onLongPress,
  });

  final List<Todo> todos;
  final String emptyHint;
  final Set<String> expandedIds;
  final List<int> Function(Todo) checklistDoneOf;
  final String? Function(int?, int?) formatTime;
  final String Function(int done, int total) checklistProgress;
  final void Function(String id) onToggleExpand;
  final void Function(Todo todo) onOpen;
  final void Function(Todo todo, bool checked) onToggleDone;
  final void Function(Todo todo, int itemIndex) onToggleChecklist;
  final void Function(Todo todo) onLongPress;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return _EmptyHint(text: emptyHint);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        final doneIndexes = checklistDoneOf(todo);
        final hasChecklist = todo.checklist.isNotEmpty;
        final expanded = expandedIds.contains(todo.id);
        final time = formatTime(todo.hour, todo.minute);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: todo.done,
                    onChanged: hasChecklist
                        ? null
                        : (value) => onToggleDone(todo, value ?? false),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: hasChecklist
                          ? () => onToggleExpand(todo.id)
                          : () => onOpen(todo),
                      onLongPress: () => onLongPress(todo),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todo.title,
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasChecklist)
                              Text(
                                checklistProgress(
                                  doneIndexes.length,
                                  todo.checklist.length,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (time != null)
                              Text(
                                time,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            TagChipsRow(tagIds: todo.tagIds),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (hasChecklist) ...[
                    IconButton(
                      onPressed: () => onOpen(todo),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () => onToggleExpand(todo.id),
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ),
                  ],
                ],
              ),
              if (hasChecklist && expanded)
                _ChecklistItems(
                  items: todo.checklist,
                  doneIndexes: doneIndexes,
                  onToggle: (itemIndex) => onToggleChecklist(todo, itemIndex),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ChecklistItems extends StatelessWidget {
  const _ChecklistItems({
    required this.items,
    required this.doneIndexes,
    required this.onToggle,
  });

  final List<String> items;
  final List<int> doneIndexes;
  final void Function(int itemIndex) onToggle;

  @override
  Widget build(BuildContext context) {
    final doneSet = doneIndexes.toSet();
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8, bottom: 4),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: doneSet.contains(i),
                  onChanged: (_) => onToggle(i),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      items[i],
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }
}
