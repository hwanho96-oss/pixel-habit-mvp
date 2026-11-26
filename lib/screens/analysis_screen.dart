import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/tag_palette.dart';
import '../l10n/app_localizations.dart';
import '../models/measure_kind.dart';
import '../models/result_table.dart';
import '../providers/app_state.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  String _formatValue(
    AppLocalizations l10n,
    ResultTable table,
    double value,
  ) {
    final shown = value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    if (table.kind == MeasureKind.time) {
      return l10n.resultValueMinutes(shown);
    }
    final unit = table.unit?.trim();
    if (unit != null && unit.isNotEmpty) {
      return l10n.resultValueWithUnit(shown, unit);
    }
    return shown;
  }

  String _periodLabel(AppLocalizations l10n, ResultPeriod period) {
    return period == ResultPeriod.week
        ? l10n.resultPeriodWeek
        : l10n.resultPeriodMonth;
  }

  Future<void> _onLongPress(
    BuildContext context,
    ResultTable table,
  ) async {
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
                title: Text(l10n.resultTableEdit),
                onTap: () => Navigator.pop(ctx, 'edit'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(l10n.resultTableDelete),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted || action == null) return;

    if (action == 'edit') {
      await context.push('/result-table/form', extra: table);
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resultTableDelete),
        content: Text(l10n.resultTableDeleteConfirm),
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
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<AppState>().deleteResultTable(table.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();
    final tables = state.resultTables;
    final atLimit = tables.length >= maxResultTables;

    return Scaffold(
      body: SafeArea(
        child: tables.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.resultTableEmptyHint,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final total = state.resultTableTotal(table);
                  final tagTotals = state.resultTableTagTotals(table);
                  final goal = table.goal;
                  final progress = (goal != null && goal > 0)
                      ? (total / goal).clamp(0.0, 1.0)
                      : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onLongPress: () => _onLongPress(context, table),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              table.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _periodLabel(l10n, table.period),
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              goal == null
                                  ? l10n.resultTotalOnly(
                                      _formatValue(l10n, table, total),
                                    )
                                  : l10n.resultTotalGoal(
                                      _formatValue(l10n, table, total),
                                      _formatValue(l10n, table, goal),
                                    ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (progress != null) ...[
                              const SizedBox(height: 8),
                              LinearProgressIndicator(value: progress),
                            ],
                            if (tagTotals.isEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.resultNoRecordsYet,
                                style: Theme.of(context).textTheme.bodySmall,
                                softWrap: true,
                              ),
                            ] else ...[
                              const SizedBox(height: 8),
                              for (final entry in tagTotals.entries)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    l10n.resultTagLine(
                                      () {
                                        final tag = state.tagById(entry.key);
                                        if (tag == null) return entry.key;
                                        final parent = tag.parentId == null
                                            ? null
                                            : state.tagById(tag.parentId!);
                                        return TagPresets.chipLabel(
                                          l10n,
                                          tag,
                                          parent: parent,
                                        );
                                      }(),
                                      _formatValue(l10n, table, entry.value),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              Text(
                                l10n.resultTagLine(
                                  l10n.resultSumLabel,
                                  _formatValue(l10n, table, total),
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (atLimit)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 4),
              child: Text(
                l10n.resultTableLimitReached(maxResultTables),
                style: Theme.of(context).textTheme.bodySmall,
                softWrap: true,
              ),
            ),
          FloatingActionButton(
            onPressed: atLimit
                ? null
                : () => context.push('/result-table/form'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
