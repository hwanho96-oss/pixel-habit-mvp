import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/goal_math.dart';
import '../l10n/app_localizations.dart';
import '../models/goal.dart';
import '../models/measure_kind.dart';
import '../providers/app_state.dart';
import 'tag_chips.dart';

class GoalCard extends StatefulWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  Timer? _tick;
  bool _notifiedDaily = false;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant GoalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.goal.id != widget.goal.id) {
      _notifiedDaily = false;
    }
    _syncTicker();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _syncTicker() {
    final state = context.read<AppState>();
    final running = state.goalTimerOf(widget.goal.id)?.isRunning == true;
    if (running && _tick == null) {
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {});
        _maybeNotifyDailyReached();
      });
    } else if (!running && _tick != null) {
      _tick?.cancel();
      _tick = null;
    }
  }

  void _maybeNotifyDailyReached() {
    if (_notifiedDaily) return;
    if (widget.goal.kind != MeasureKind.time) return;
    final state = context.read<AppState>();
    final l10n = AppLocalizations.of(context)!;
    final daily = dailyGoalTargetFor(widget.goal);
    if (daily <= 0) return;
    final logged = state.goalValueToday(widget.goal.id);
    final timerMinutes = state.goalTimerElapsedMs(widget.goal.id) ~/ 60000;
    if (logged + timerMinutes >= daily) {
      _notifiedDaily = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.goalDailyReached)),
      );
    }
  }

  String _formatProgress(
    AppLocalizations l10n, {
    required int current,
    required int target,
  }) {
    if (widget.goal.kind == MeasureKind.time) {
      return l10n.goalProgressMinutes(current, target);
    }
    return l10n.goalProgressAmount(
      current,
      target,
      widget.goal.unit?.trim() ?? '',
    );
  }

  String _formatPeriodSum(AppLocalizations l10n, int sum) {
    final isWeek = widget.goal.period == GoalPeriod.week;
    if (widget.goal.kind == MeasureKind.time) {
      return isWeek
          ? l10n.goalPeriodSumWeekMinutes(sum)
          : l10n.goalPeriodSumMonthMinutes(sum);
    }
    final unit = widget.goal.unit?.trim() ?? '';
    return isWeek
        ? l10n.goalPeriodSumWeekAmount(sum, unit)
        : l10n.goalPeriodSumMonthAmount(sum, unit);
  }

  String _formatElapsed(int ms) {
    final totalSeconds = ms ~/ 1000;
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) {
      return '$h:$mm:$ss';
    }
    return '$mm:$ss';
  }

  Future<void> _showActions() async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: Text(l10n.goalEdit),
                onTap: () => Navigator.pop(ctx, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.goalDelete),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
            ],
          ),
        );
      },
    );
    if (!mounted) return;
    if (action == 'edit') widget.onEdit();
    if (action == 'delete') widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final daily = dailyGoalTargetFor(widget.goal);
    final today = state.goalValueToday(widget.goal.id);
    final periodSum = state.goalPeriodSum(widget.goal);
    final progress = daily <= 0 ? 0.0 : (today / daily).clamp(0.0, 1.0);
    final timer = state.goalTimerOf(widget.goal.id);
    final elapsedMs = state.goalTimerElapsedMs(widget.goal.id);
    final isRunning = timer?.isRunning == true;

    // Keep ticker in sync when provider updates.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncTicker();
    });

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onLongPress: _showActions,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.goal.name,
                softWrap: true,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _formatProgress(l10n, current: today, target: daily),
                softWrap: true,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text(
                _formatPeriodSum(l10n, periodSum),
                softWrap: true,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (widget.goal.tagIds.isNotEmpty) ...[
                const SizedBox(height: 8),
                TagChipsRow(tagIds: widget.goal.tagIds),
              ],
              const SizedBox(height: 12),
              if (widget.goal.kind == MeasureKind.amount)
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () {
                        final step = widget.goal.step ?? 1;
                        state.adjustGoalAmount(widget.goal.id, -step);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () {
                        final step = widget.goal.step ?? 1;
                        state.adjustGoalAmount(widget.goal.id, step);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              else ...[
                Text(
                  _formatElapsed(elapsedMs),
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: isRunning
                          ? null
                          : () async {
                              final before = today;
                              await state.startGoalTimer(widget.goal.id);
                              if (!mounted) return;
                              _notifiedDaily = before >= daily;
                              setState(() {});
                              _syncTicker();
                            },
                      child: Text(l10n.goalTimerStart),
                    ),
                    FilledButton.tonal(
                      onPressed: isRunning
                          ? () async {
                              await state.pauseGoalTimer(widget.goal.id);
                              if (!mounted) return;
                              setState(() {});
                              _syncTicker();
                            }
                          : null,
                      child: Text(l10n.goalTimerPause),
                    ),
                    FilledButton(
                      onPressed: timer == null
                          ? null
                          : () async {
                              await state.stopGoalTimer(widget.goal.id);
                              if (!mounted) return;
                              _notifiedDaily = false;
                              setState(() {});
                              _syncTicker();
                            },
                      child: Text(l10n.goalTimerStop),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
