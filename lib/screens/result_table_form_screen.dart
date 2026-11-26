import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/measure_kind.dart';
import '../models/result_table.dart';
import '../providers/app_state.dart';
import '../widgets/tag_chips.dart';
import '../widgets/tag_picker_sheet.dart';

class ResultTableFormScreen extends StatefulWidget {
  const ResultTableFormScreen({super.key, this.initial});

  final ResultTable? initial;

  @override
  State<ResultTableFormScreen> createState() => _ResultTableFormScreenState();
}

class _ResultTableFormScreenState extends State<ResultTableFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late final TextEditingController _goalController;
  late MeasureKind _kind;
  late ResultPeriod _period;
  late Set<String> _tagIds;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _unitController = TextEditingController(text: initial?.unit ?? '');
    _goalController = TextEditingController(
      text: initial?.goal == null
          ? ''
          : (initial!.goal == initial.goal!.roundToDouble()
              ? initial.goal!.toInt().toString()
              : initial.goal!.toString()),
    );
    _kind = initial?.kind ?? MeasureKind.amount;
    _period = initial?.period ?? ResultPeriod.week;
    _tagIds = {...?(initial?.tagIds)};
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty && _tagIds.isNotEmpty;

  Future<void> _pickTags() async {
    final result = await showTagPicker(
      context: context,
      initiallySelected: _tagIds,
    );
    if (result != null && mounted) {
      setState(() => _tagIds = result);
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;
    final l10n = AppLocalizations.of(context)!;
    final state = context.read<AppState>();
    final goalText = _goalController.text.trim();
    final goal = goalText.isEmpty ? null : double.tryParse(goalText);
    if (goalText.isNotEmpty && goal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.resultGoalInvalid)),
      );
      return;
    }

    final table = ResultTable(
      id: widget.initial?.id ??
          'rt_${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      kind: _kind,
      unit: _kind == MeasureKind.amount
          ? (_unitController.text.trim().isEmpty
              ? null
              : _unitController.text.trim())
          : null,
      tagIds: _tagIds.toList(),
      goal: goal,
      period: _period,
    );

    if (_isEdit) {
      await state.updateResultTable(table);
    } else {
      final ok = await state.addResultTable(table);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.resultTableLimitReached(maxResultTables)),
          ),
        );
        return;
      }
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? l10n.resultTableEditTitle : l10n.resultTableCreateTitle,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(l10n.resultTableNameLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: l10n.resultTableNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.measureKindLabel),
          const SizedBox(height: 8),
          SegmentedButton<MeasureKind>(
            segments: [
              ButtonSegment(
                value: MeasureKind.amount,
                label: Text(
                  l10n.measureKindAmount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ButtonSegment(
                value: MeasureKind.time,
                label: Text(
                  l10n.measureKindTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (next) {
              setState(() => _kind = next.first);
            },
            showSelectedIcon: false,
          ),
          if (_kind == MeasureKind.amount) ...[
            const SizedBox(height: 16),
            Text(l10n.measureUnitLabel),
            const SizedBox(height: 8),
            TextField(
              controller: _unitController,
              decoration: InputDecoration(
                hintText: l10n.measureUnitHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(l10n.routineSectionTags),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickTags,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.tagSelectLabel,
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              child: _tagIds.isEmpty
                  ? Text(
                      l10n.tagSelectHint,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : TagChipsRow(tagIds: _tagIds.toList()),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.resultGoalLabel),
          const SizedBox(height: 8),
          TextField(
            controller: _goalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: l10n.resultGoalHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.resultPeriodLabel),
          const SizedBox(height: 8),
          SegmentedButton<ResultPeriod>(
            segments: [
              ButtonSegment(
                value: ResultPeriod.week,
                label: Text(
                  l10n.resultPeriodWeek,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ButtonSegment(
                value: ResultPeriod.month,
                label: Text(
                  l10n.resultPeriodMonth,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            selected: {_period},
            onSelectionChanged: (next) {
              setState(() => _period = next.first);
            },
            showSelectedIcon: false,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _canSave ? _save : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.routineSave,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
