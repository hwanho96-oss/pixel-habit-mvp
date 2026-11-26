import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/day_clock.dart';
import '../data/goal_math.dart';
import '../l10n/app_localizations.dart';
import '../models/goal.dart';
import '../models/measure_kind.dart';
import '../models/task.dart';
import '../providers/app_state.dart';
import '../widgets/charts/progress_bar.dart';
import '../widgets/charts/simple_bar_chart.dart';

/// Bottom "분석" tab — calendar (read-only) + goal result cards. No create UI.
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late DateTime _visibleMonth;
  String? _selectedTaskId;

  @override
  void initState() {
    super.initState();
    final now = DayClock.logicalNow();
    _visibleMonth = DateTime(now.year, now.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  Future<void> _pickTask(List<Task> tasks) async {
    final l10n = AppLocalizations.of(context)!;
    if (tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.analysisNoTasks)),
      );
      return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.45,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: tasks.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Text(
                        l10n.analysisSelectTask,
                        style: Theme.of(context).textTheme.titleMedium,
                        softWrap: true,
                      ),
                    );
                  }
                  final task = tasks[index - 1];
                  final isSelected = task.id == _selectedTaskId;
                  return ListTile(
                    title: Text(task.title, softWrap: true),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.pop(ctx, task.id),
                  );
                },
              );
            },
          ),
        );
      },
    );

    if (selected != null && mounted) {
      setState(() => _selectedTaskId = selected);
    }
  }

  String _formatProgress(
    AppLocalizations l10n,
    Goal goal, {
    required int current,
    required int target,
  }) {
    if (goal.kind == MeasureKind.time) {
      return l10n.goalProgressMinutes(current, target);
    }
    return l10n.goalProgressAmount(
      current,
      target,
      goal.unit?.trim() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final tasks = [...state.tasks]
      ..sort((a, b) => a.title.compareTo(b.title));
    Task? selectedTask;
    if (_selectedTaskId != null) {
      for (final t in tasks) {
        if (t.id == _selectedTaskId) {
          selectedTask = t;
          break;
        }
      }
    }
    final completedDays = selectedTask == null
        ? <String>{}
        : state.completionDateKeysForTask(selectedTask.id);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          children: [
            _CalendarSection(
              visibleMonth: _visibleMonth,
              completedDays: completedDays,
              hasSelection: selectedTask != null,
              selectedTaskTitle: selectedTask?.title,
              onPrev: () => _shiftMonth(-1),
              onNext: () => _shiftMonth(1),
              onSelectTask: () => _pickTask(tasks),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.analysisResultsTitle,
              style: Theme.of(context).textTheme.titleMedium,
              softWrap: true,
            ),
            const SizedBox(height: 8),
            if (state.goals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.analysisEmptyGoals,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            else
              for (final goal in state.goals)
                _GoalResultCard(
                  goal: goal,
                  formatProgress: (current, target) => _formatProgress(
                    l10n,
                    goal,
                    current: current,
                    target: target,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({
    required this.visibleMonth,
    required this.completedDays,
    required this.hasSelection,
    required this.selectedTaskTitle,
    required this.onPrev,
    required this.onNext,
    required this.onSelectTask,
  });

  final DateTime visibleMonth;
  final Set<String> completedDays;
  final bool hasSelection;
  final String? selectedTaskTitle;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSelectTask;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final year = visibleMonth.year;
    final month = visibleMonth.month;
    final firstWeekday = DateTime(year, month, 1).weekday; // Mon=1 … Sun=7
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leading = firstWeekday - 1;
    final totalCells = leading + daysInMonth;
    final rows = ((totalCells + 6) ~/ 7);
    final weekdayLabels = [
      l10n.weekdayMon,
      l10n.weekdayTue,
      l10n.weekdayWed,
      l10n.weekdayThu,
      l10n.weekdayFri,
      l10n.weekdaySat,
      l10n.weekdaySun,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onPrev,
                        icon: const Icon(Icons.chevron_left),
                        tooltip: l10n.analysisPrevMonth,
                      ),
                      Expanded(
                        child: Text(
                          l10n.analysisYearMonth(year, month),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: onNext,
                        icon: const Icon(Icons.chevron_right),
                        tooltip: l10n.analysisNextMonth,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onSelectTask,
                  child: Text(
                    l10n.analysisSelectTask,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            if (!hasSelection)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l10n.analysisPickTaskHint,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              )
            else if (selectedTaskTitle != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  selectedTaskTitle!,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Row(
              children: [
                for (final label in weekdayLabels)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            for (var row = 0; row < rows; row++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    for (var col = 0; col < 7; col++)
                      Expanded(
                        child: _DayCell(
                          day: () {
                            final index = row * 7 + col;
                            final dayNum = index - leading + 1;
                            if (dayNum < 1 || dayNum > daysInMonth) {
                              return null;
                            }
                            return dayNum;
                          }(),
                          highlighted: () {
                            final index = row * 7 + col;
                            final dayNum = index - leading + 1;
                            if (!hasSelection) return false;
                            if (dayNum < 1 || dayNum > daysInMonth) {
                              return false;
                            }
                            final key = DayClock.keyFromDate(
                              DateTime(year, month, dayNum),
                            );
                            return completedDays.contains(key);
                          }(),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.highlighted,
  });

  final int? day;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return const SizedBox(height: 36);
    }
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: highlighted ? scheme.primaryContainer : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$day',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: highlighted
                        ? scheme.onPrimaryContainer
                        : scheme.onSurface,
                    fontWeight: highlighted ? FontWeight.w600 : null,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalResultCard extends StatelessWidget {
  const _GoalResultCard({
    required this.goal,
    required this.formatProgress,
  });

  final Goal goal;
  final String Function(int current, int target) formatProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final dailyTarget = dailyGoalTargetFor(goal);
    final todayValue = state.goalValueToday(goal.id);
    final periodSum = state.goalPeriodSum(goal);
    final periodTarget = goal.periodTarget;
    final dailyProgress =
        dailyTarget <= 0 ? 0.0 : (todayValue / dailyTarget).clamp(0.0, 1.0);
    final periodProgress =
        periodTarget <= 0 ? 0.0 : (periodSum / periodTarget).clamp(0.0, 1.0);
    final periodLabel = goal.period == GoalPeriod.week
        ? l10n.resultPeriodWeek
        : l10n.resultPeriodMonth;

    final keys = lastNDateKeys(7);
    final barValues = [
      for (final key in keys) state.goalValueOn(goal.id, key),
    ];
    final barLabels = [
      for (final key in keys)
        () {
          final d = DateTime.tryParse(key);
          if (d == null) return '';
          return switch (d.weekday) {
            1 => l10n.weekdayMon,
            2 => l10n.weekdayTue,
            3 => l10n.weekdayWed,
            4 => l10n.weekdayThu,
            5 => l10n.weekdayFri,
            6 => l10n.weekdaySat,
            _ => l10n.weekdaySun,
          };
        }(),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              goal.name,
              softWrap: true,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(l10n.analysisProgressToday, softWrap: true),
            const SizedBox(height: 4),
            Text(
              formatProgress(todayValue, dailyTarget),
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            ChartProgressBar(value: dailyProgress),
            const SizedBox(height: 12),
            Text(periodLabel, softWrap: true),
            const SizedBox(height: 4),
            Text(
              formatProgress(periodSum, periodTarget),
              softWrap: true,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            ChartProgressBar(value: periodProgress),
            const SizedBox(height: 12),
            Text(l10n.analysisRecent7Days, softWrap: true),
            const SizedBox(height: 8),
            SimpleBarChart(values: barValues, labels: barLabels),
          ],
        ),
      ),
    );
  }
}
