import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/goal_math.dart';
import '../l10n/app_localizations.dart';
import '../models/goal.dart';
import '../models/measure_kind.dart';
import '../providers/app_state.dart';
import '../widgets/tag_chips.dart';
import '../widgets/tag_picker_sheet.dart';

class GoalFormArgs {
  const GoalFormArgs({this.goal});

  final Goal? goal;
}

class GoalFormScreen extends StatefulWidget {
  const GoalFormScreen({super.key, this.initialGoal});

  final Goal? initialGoal;

  factory GoalFormScreen.fromArgs(GoalFormArgs args) {
    return GoalFormScreen(initialGoal: args.goal);
  }

  @override
  State<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late final TextEditingController _unitController;
  late final TextEditingController _stepController;
  late MeasureKind _kind;
  late GoalPeriod _period;
  late Set<String> _tagIds;

  bool get _isEdit => widget.initialGoal != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialGoal;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _targetController = TextEditingController(
      text: initial == null ? '' : initial.periodTarget.toString(),
    );
    _unitController = TextEditingController(text: initial?.unit ?? '');
    _stepController = TextEditingController(
      text: initial?.step == null ? '' : initial!.step.toString(),
    );
    _kind = initial?.kind ?? MeasureKind.amount;
    _period = initial?.period ?? GoalPeriod.week;
    _tagIds = {...?(initial?.tagIds)};
    for (final c in [
      _nameController,
      _targetController,
      _unitController,
      _stepController,
    ]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  int? get _parsedTarget {
    final text = _targetController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  int? get _parsedStep {
    final text = _stepController.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  bool get _canSave {
    if (_nameController.text.trim().isEmpty) return false;
    final target = _parsedTarget;
    if (target == null || target <= 0) return false;
    if (_kind == MeasureKind.amount) {
      if (_unitController.text.trim().isEmpty) return false;
      final step = _parsedStep;
      if (step == null || step <= 0) return false;
    }
    return true;
  }

  int? get _dailyPreview {
    final target = _parsedTarget;
    if (target == null || target <= 0) return null;
    return dailyGoalTarget(
      periodTarget: target,
      period: _period,
      kind: _kind,
    );
  }

  Future<void> _pickTags() async {
    final result = await showTagPicker(
      context: context,
      initiallySelected: _tagIds,
    );
    if (result != null && mounted) {
      setState(() => _tagIds = result);
    }
  }

  Future<void> _submit() async {
    if (!_canSave) return;
    final target = _parsedTarget!;
    final state = context.read<AppState>();
    final goal = Goal(
      id: widget.initialGoal?.id ??
          'goal_${DateTime.now().microsecondsSinceEpoch}',
      name: _nameController.text.trim(),
      kind: _kind,
      period: _period,
      periodTarget: target,
      unit: _kind == MeasureKind.amount ? _unitController.text.trim() : null,
      step: _kind == MeasureKind.amount ? _parsedStep : null,
      tagIds: _tagIds.toList(),
    );
    if (_isEdit) {
      await state.updateGoal(goal);
    } else {
      await state.addGoal(goal);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final daily = _dailyPreview;
    final previewText = daily == null
        ? null
        : (_kind == MeasureKind.time
            ? l10n.goalDailyPreviewMinutes(daily)
            : l10n.goalDailyPreviewAmount(
                daily,
                _unitController.text.trim(),
              ));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? l10n.goalFormTitleEdit : l10n.goalFormTitle,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: l10n.close,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.goalNameLabel),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: l10n.goalNameHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
              ],
            ),
          ),
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.goalPeriodLabel),
                const SizedBox(height: 8),
                SegmentedButton<GoalPeriod>(
                  segments: [
                    ButtonSegment(
                      value: GoalPeriod.week,
                      label: Text(
                        l10n.goalPeriodWeek,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ButtonSegment(
                      value: GoalPeriod.month,
                      label: Text(
                        l10n.goalPeriodMonth,
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
              ],
            ),
          ),
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _kind == MeasureKind.time
                      ? l10n.goalPeriodTargetMinutesLabel
                      : l10n.goalPeriodTargetLabel,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: _kind == MeasureKind.time
                        ? l10n.goalPeriodTargetMinutesHint
                        : l10n.goalPeriodTargetHint,
                    border: const OutlineInputBorder(),
                  ),
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
                  const SizedBox(height: 16),
                  Text(l10n.goalStepLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _stepController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: l10n.goalStepHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                if (previewText != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    previewText,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ],
            ),
          ),
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                            softWrap: true,
                          )
                        : TagChipsRow(tagIds: _tagIds.toList()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canSave ? _submit : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _isEdit ? l10n.routineSave : l10n.routineSubmit,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
