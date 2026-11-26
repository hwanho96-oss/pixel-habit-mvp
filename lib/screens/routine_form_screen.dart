import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/day_clock.dart';
import '../l10n/app_localizations.dart';
import '../models/measure_kind.dart';
import '../models/routine.dart';
import '../models/todo.dart';
import '../providers/app_state.dart';
import '../widgets/tag_chips.dart';
import '../widgets/tag_picker_sheet.dart';

enum FormItemType { routine, todo }

class ItemFormArgs {
  const ItemFormArgs({
    required this.type,
    this.routine,
    this.todo,
  });

  final FormItemType type;
  final Routine? routine;
  final Todo? todo;
}

class ItemFormScreen extends StatefulWidget {
  const ItemFormScreen({
    super.key,
    required this.type,
    this.initialRoutine,
    this.initialTodo,
  });

  final FormItemType type;
  final Routine? initialRoutine;
  final Todo? initialTodo;

  factory ItemFormScreen.fromArgs(ItemFormArgs args) {
    return ItemFormScreen(
      type: args.type,
      initialRoutine: args.routine,
      initialTodo: args.todo,
    );
  }

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _checklistController;
  late DateTime _date;
  int? _hour;
  int? _minute;
  late Set<int> _weekdays;
  late Set<String> _selectedTagIds;
  late List<String> _checklist;
  late final TextEditingController _amountController;
  late final TextEditingController _unitController;
  MeasureKind _measureKind = MeasureKind.amount;
  bool _hasMeasure = false;

  bool get _isRoutine => widget.type == FormItemType.routine;

  bool get _isEdit => _isRoutine
      ? widget.initialRoutine != null
      : widget.initialTodo != null;

  @override
  void initState() {
    super.initState();
    final now = DayClock.logicalNow();
    final routine = widget.initialRoutine;
    final todo = widget.initialTodo;

    _titleController = TextEditingController(
      text: routine?.title ?? todo?.title ?? '',
    );
    _checklistController = TextEditingController();
    _date = routine?.date ??
        todo?.date ??
        DateTime(now.year, now.month, now.day);
    _hour = routine?.hour ?? todo?.hour;
    _minute = routine?.minute ?? todo?.minute;
    _weekdays = {...?routine?.repeatWeekdays};
    _selectedTagIds = {...?(routine?.tagIds ?? todo?.tagIds)};
    _checklist = [...?(routine?.checklist ?? todo?.checklist)];
    final amount = routine?.amount ?? todo?.amount;
    final unit = routine?.unit ?? todo?.unit;
    final kind = routine?.kind ?? todo?.kind;
    _hasMeasure = amount != null || kind != null || (unit != null && unit.isNotEmpty);
    _measureKind = kind ?? MeasureKind.amount;
    _amountController = TextEditingController(
      text: amount == null
          ? ''
          : (amount == amount.roundToDouble()
              ? amount.toInt().toString()
              : amount.toString()),
    );
    _unitController = TextEditingController(text: unit ?? '');
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _checklistController.dispose();
    _amountController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  List<String> _weekdayLabels(AppLocalizations l10n) => [
        l10n.weekdayMon,
        l10n.weekdayTue,
        l10n.weekdayWed,
        l10n.weekdayThu,
        l10n.weekdayFri,
        l10n.weekdaySat,
        l10n.weekdaySun,
      ];

  String _formTitle(AppLocalizations l10n) {
    if (_isRoutine) {
      return _isEdit ? l10n.routineFormTitleEdit : l10n.routineFormTitle;
    }
    return _isEdit ? l10n.todoFormTitleEdit : l10n.todoFormTitle;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickTime() async {
    final initial = TimeOfDay(
      hour: _hour ?? TimeOfDay.now().hour,
      minute: _minute ?? 0,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        _hour = picked.hour;
        _minute = picked.minute;
      });
    }
  }

  void _addChecklistItem() {
    final text = _checklistController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _checklist = [..._checklist, text];
      _checklistController.clear();
    });
  }

  Future<void> _openTagPicker() async {
    final result = await showTagPicker(
      context: context,
      initiallySelected: _selectedTagIds,
    );
    if (result != null && mounted) {
      setState(() => _selectedTagIds = result);
    }
  }

  ({double? amount, String? unit, MeasureKind? kind}) _measureFields() {
    if (!_hasMeasure) {
      return (amount: null, unit: null, kind: null);
    }
    final raw = _amountController.text.trim();
    final parsed = raw.isEmpty ? null : double.tryParse(raw);
    final unit = _measureKind == MeasureKind.amount
        ? (_unitController.text.trim().isEmpty
            ? null
            : _unitController.text.trim())
        : null;
    return (
      amount: parsed,
      unit: unit,
      kind: _measureKind,
    );
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final measure = _measureFields();
    if (_hasMeasure &&
        _amountController.text.trim().isNotEmpty &&
        measure.amount == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.measureAmountInvalid)),
      );
      return;
    }

    final state = context.read<AppState>();

    if (_isRoutine) {
      final existing = widget.initialRoutine;
      final remappedDone = existing == null
          ? const <int>[]
          : AppState.remapChecklistDone(
              previousDone: existing.checklistDone,
              previousChecklist: existing.checklist,
              nextChecklist: _checklist,
            );
      final routine = Routine(
        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        checklist: _checklist,
        checklistDone: remappedDone,
        checklistDateKey: existing?.checklistDateKey,
        date: _date,
        hour: _hour,
        minute: _minute,
        repeatWeekdays: _weekdays.toList()..sort(),
        tagIds: _selectedTagIds.toList(),
        lastDoneDate: existing?.lastDoneDate,
        amount: measure.amount,
        unit: measure.unit,
        kind: measure.kind,
      );
      if (_isEdit) {
        await state.updateRoutine(routine);
      } else {
        await state.addRoutine(routine);
      }
    } else {
      final existing = widget.initialTodo;
      final remappedDone = existing == null
          ? const <int>[]
          : AppState.remapChecklistDone(
              previousDone: existing.checklistDone,
              previousChecklist: existing.checklist,
              nextChecklist: _checklist,
            );
      final todo = Todo(
        id: existing?.id ??
            '${DateTime.now().microsecondsSinceEpoch}_t',
        title: title,
        checklist: _checklist,
        checklistDone: remappedDone,
        date: _date,
        hour: _hour,
        minute: _minute,
        tagIds: _selectedTagIds.toList(),
        done: existing?.done ?? false,
        doneDate: existing?.doneDate,
        amount: measure.amount,
        unit: measure.unit,
        kind: measure.kind,
      );
      if (_isEdit) {
        await state.updateTodo(todo);
      } else {
        await state.addTodo(todo);
      }
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canSubmit = _titleController.text.trim().isNotEmpty;
    final timeText = (_hour != null && _minute != null)
        ? '${_hour!.toString().padLeft(2, '0')}:${_minute!.toString().padLeft(2, '0')}'
        : l10n.routineTimeUnset;
    final weekdayLabels = _weekdayLabels(l10n);
    final titleHint =
        _isRoutine ? l10n.routineTitleHint : l10n.todoTitleHint;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _formTitle(l10n),
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
                Text(l10n.routineSectionTitle),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: titleHint,
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
                Text(l10n.routineSectionChecklist),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _checklistController,
                        decoration: InputDecoration(
                          hintText: l10n.routineChecklistHint,
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addChecklistItem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _addChecklistItem,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                for (var i = 0; i < _checklist.length; i++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _checklist[i],
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _checklist = [..._checklist]..removeAt(i);
                        });
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
              ],
            ),
          ),
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.routineSectionSchedule),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.routineDateLabel),
                  subtitle: Text(DayClock.keyFromDate(_date)),
                  onTap: _pickDate,
                  trailing: const Icon(Icons.calendar_today_outlined),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.routineTimeLabel),
                  subtitle: Text(timeText),
                  onTap: _pickTime,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_hour != null)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _hour = null;
                              _minute = null;
                            });
                          },
                          child: Text(l10n.routineTimeClear),
                        ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isRoutine)
            _FormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.routineSectionRepeat,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          l10n.routineRepeatEverydayHint,
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < 7; i++)
                        FilterChip(
                          label: Text(
                            weekdayLabels[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          selected: _weekdays.contains(i + 1),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _weekdays = {..._weekdays, i + 1};
                              } else {
                                _weekdays = {..._weekdays}..remove(i + 1);
                              }
                            });
                          },
                        ),
                    ],
                  ),
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
                  onTap: _openTagPicker,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.tagSelectLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: _selectedTagIds.isEmpty
                        ? Text(
                            l10n.tagSelectHint,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : TagChipsRow(tagIds: _selectedTagIds.toList()),
                  ),
                ),
              ],
            ),
          ),
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.measureSectionTitle,
                    softWrap: true,
                  ),
                  subtitle: Text(
                    l10n.measureSectionHint,
                    softWrap: true,
                  ),
                  value: _hasMeasure,
                  onChanged: (v) => setState(() => _hasMeasure = v),
                ),
                if (_hasMeasure) ...[
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
                    selected: {_measureKind},
                    onSelectionChanged: (next) {
                      setState(() => _measureKind = next.first);
                    },
                    showSelectedIcon: false,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: _measureKind == MeasureKind.time
                          ? l10n.measureAmountMinutesLabel
                          : l10n.measureAmountLabel,
                      hintText: _measureKind == MeasureKind.time
                          ? l10n.measureAmountMinutesHint
                          : l10n.measureAmountHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (_measureKind == MeasureKind.amount) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _unitController,
                      decoration: InputDecoration(
                        labelText: l10n.measureUnitLabel,
                        hintText: l10n.measureUnitHint,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canSubmit ? _submit : null,
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
