import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/day_clock.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/app_state.dart';
import '../widgets/tag_chips.dart';
import '../widgets/tag_picker_sheet.dart';

class TaskFormArgs {
  const TaskFormArgs({this.task});

  final Task? task;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    this.initialTask,
  });

  final Task? initialTask;

  factory TaskFormScreen.fromArgs(TaskFormArgs args) {
    return TaskFormScreen(initialTask: args.task);
  }

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _checklistController;
  late DateTime _date;
  int? _hour;
  int? _minute;
  late bool _repeats;
  late Set<int> _weekdays;
  late Set<String> _selectedTagIds;
  late List<String> _checklist;

  bool get _isEdit => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final now = DayClock.logicalNow();
    final task = widget.initialTask;

    _titleController = TextEditingController(text: task?.title ?? '');
    _checklistController = TextEditingController();
    _date = task?.date ?? DateTime(now.year, now.month, now.day);
    _hour = task?.hour;
    _minute = task?.minute;
    _repeats = task?.isRepeating ?? false;
    _weekdays = {...?task?.repeatWeekdays};
    _selectedTagIds = {...?task?.tagIds};
    _checklist = [...?task?.checklist];
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _checklistController.dispose();
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

  List<int> _resolvedWeekdays() {
    if (!_repeats) return const [];
    if (_weekdays.isEmpty) return const [1, 2, 3, 4, 5, 6, 7];
    return _weekdays.toList()..sort();
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final state = context.read<AppState>();
    final existing = widget.initialTask;
    final remappedDone = existing == null
        ? const <int>[]
        : AppState.remapChecklistDone(
            previousDone: existing.checklistDone,
            previousChecklist: existing.checklist,
            nextChecklist: _checklist,
          );
    final weekdays = _resolvedWeekdays();
    final isRepeating = weekdays.isNotEmpty;

    final task = Task(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      checklist: _checklist,
      checklistDone: remappedDone,
      checklistDateKey: isRepeating ? existing?.checklistDateKey : null,
      date: _date,
      hour: _hour,
      minute: _minute,
      repeatWeekdays: weekdays,
      tagIds: _selectedTagIds.toList(),
      lastDoneDate: isRepeating ? existing?.lastDoneDate : null,
      done: isRepeating ? false : (existing?.done ?? false),
      doneDate: isRepeating ? null : existing?.doneDate,
    );

    if (_isEdit) {
      await state.updateTask(task);
    } else {
      await state.addTask(task);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? l10n.taskFormTitleEdit : l10n.taskFormTitle,
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
                    hintText: l10n.taskTitleHint,
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
          _FormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.taskRepeatSwitch,
                    softWrap: true,
                  ),
                  value: _repeats,
                  onChanged: (v) {
                    setState(() {
                      _repeats = v;
                      if (!v) _weekdays = {};
                    });
                  },
                ),
                if (_repeats) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.routineRepeatEverydayHint,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodySmall,
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
