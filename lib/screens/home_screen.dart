import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/day_clock.dart';
import '../data/economy.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/app_state.dart';
import '../ui/layout_config.dart';
import '../widgets/character_preview.dart';
import '../widgets/tag_chips.dart';
import 'task_form_screen.dart';

enum _HomeSegment { tasks, analysis }

enum _TaskFilter { all, repeat, once }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeSegment _segment = _HomeSegment.tasks;
  _TaskFilter _filter = _TaskFilter.all;
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
    context.push('/item/form');
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

  List<Task> _filteredTasks(List<Task> source) {
    switch (_filter) {
      case _TaskFilter.all:
        return source;
      case _TaskFilter.repeat:
        return source.where((t) => t.isRepeating).toList();
      case _TaskFilter.once:
        return source.where((t) => !t.isRepeating).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final showFab = _segment == _HomeSegment.tasks;

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
                        value: _HomeSegment.tasks,
                        label: Text(
                          l10n.segmentTasks,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      ButtonSegment(
                        value: _HomeSegment.analysis,
                        label: Text(
                          l10n.segmentAnalysis,
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
                  child: _segment == _HomeSegment.tasks
                      ? Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    FilterChip(
                                      label: Text(l10n.filterAll),
                                      selected: _filter == _TaskFilter.all,
                                      onSelected: (_) {
                                        setState(
                                          () => _filter = _TaskFilter.all,
                                        );
                                      },
                                    ),
                                    FilterChip(
                                      label: Text(l10n.filterRepeat),
                                      selected: _filter == _TaskFilter.repeat,
                                      onSelected: (_) {
                                        setState(
                                          () => _filter = _TaskFilter.repeat,
                                        );
                                      },
                                    ),
                                    FilterChip(
                                      label: Text(l10n.filterOnce),
                                      selected: _filter == _TaskFilter.once,
                                      onSelected: (_) {
                                        setState(
                                          () => _filter = _TaskFilter.once,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: _TaskList(
                                tasks: _filteredTasks(state.todaysTasks),
                                emptyHint: l10n.emptyTasksHint,
                                expandedIds: _expandedIds,
                                isDone: state.isTaskDoneToday,
                                checklistDoneOf: state.effectiveChecklistDone,
                                formatTime: _formatTime,
                                checklistProgress: l10n.checklistProgress,
                                onToggleExpand: _toggleExpanded,
                                onOpen: (task) {
                                  context.push(
                                    '/item/form',
                                    extra: TaskFormArgs(task: task),
                                  );
                                },
                                onToggleDone: (task, checked) async {
                                  final welcomeBack = _isAwayTwoOrMoreDays(
                                    state.lastCheckDateKey,
                                  );
                                  final outcome =
                                      await state.toggleTaskDone(task.id);
                                  if (!mounted) return;
                                  if (checked) {
                                    _showCompleteSnackBar(
                                      outcome: outcome,
                                      welcomeBack: welcomeBack,
                                      gold: Economy.taskCompleteGold,
                                    );
                                  }
                                },
                                onToggleChecklist: (task, itemIndex) async {
                                  final welcomeBack = _isAwayTwoOrMoreDays(
                                    state.lastCheckDateKey,
                                  );
                                  final outcome =
                                      await state.toggleChecklistItem(
                                    task.id,
                                    itemIndex,
                                  );
                                  if (!mounted) return;
                                  _showCompleteSnackBar(
                                    outcome: outcome,
                                    welcomeBack: welcomeBack,
                                    gold: Economy.taskCompleteGold,
                                  );
                                },
                                onLongPress: (task) {
                                  _confirmDelete(
                                    onConfirm: () =>
                                        state.deleteTask(task.id),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              l10n.analysisComingSoon,
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: _onFabPressed,
              child: const Icon(Icons.add),
            )
          : null,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CharacterPreview(
          equipped: equipped,
          equippedTitleName: equippedTitleName,
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

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
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

  final List<Task> tasks;
  final String emptyHint;
  final Set<String> expandedIds;
  final bool Function(Task) isDone;
  final List<int> Function(Task) checklistDoneOf;
  final String? Function(int?, int?) formatTime;
  final String Function(int done, int total) checklistProgress;
  final void Function(String id) onToggleExpand;
  final void Function(Task task) onOpen;
  final void Function(Task task, bool checked) onToggleDone;
  final void Function(Task task, int itemIndex) onToggleChecklist;
  final void Function(Task task) onLongPress;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _EmptyHint(text: emptyHint);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final done = isDone(task);
        final doneIndexes = checklistDoneOf(task);
        final hasChecklist = task.checklist.isNotEmpty;
        final expanded = expandedIds.contains(task.id);
        final time = formatTime(task.hour, task.minute);

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
                        : (value) => onToggleDone(task, value ?? false),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: hasChecklist
                          ? () => onToggleExpand(task.id)
                          : () => onOpen(task),
                      onLongPress: () => onLongPress(task),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (hasChecklist)
                              Text(
                                checklistProgress(
                                  doneIndexes.length,
                                  task.checklist.length,
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
                            TagChipsRow(tagIds: task.tagIds),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (hasChecklist) ...[
                    IconButton(
                      onPressed: () => onOpen(task),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () => onToggleExpand(task.id),
                      icon: Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                      ),
                    ),
                  ],
                ],
              ),
              if (hasChecklist && expanded)
                _ChecklistItems(
                  items: task.checklist,
                  doneIndexes: doneIndexes,
                  onToggle: (itemIndex) =>
                      onToggleChecklist(task, itemIndex),
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
