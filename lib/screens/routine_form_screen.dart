import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/day_clock.dart';
import '../data/default_tags.dart';
import '../l10n/app_localizations.dart';
import '../models/routine.dart';
import '../models/todo.dart';
import '../providers/app_state.dart';

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
  late Set<String> _selectedTags;
  late List<String> _checklist;

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
    _selectedTags = {...?(routine?.tags ?? todo?.tags)};
    _checklist = [...?(routine?.checklist ?? todo?.checklist)];
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _checklistController.dispose();
    super.dispose();
  }

  String _defaultTagLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case DefaultTags.health:
        return l10n.tagHealth;
      case DefaultTags.study:
        return l10n.tagStudy;
      case DefaultTags.selfGrowth:
        return l10n.tagSelfGrowth;
      case DefaultTags.relationship:
        return l10n.tagRelationship;
      default:
        return id;
    }
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

  Future<void> _addCustomTag() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final tag = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.addCustomTagTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.addCustomTagHint),
            onSubmitted: (value) => Navigator.pop(ctx, value.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(l10n.add),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (tag == null || tag.isEmpty || !mounted) return;

    await context.read<AppState>().addCustomTag(tag);
    setState(() => _selectedTags = {..._selectedTags, tag});
  }

  Future<void> _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final state = context.read<AppState>();

    if (_isRoutine) {
      final existing = widget.initialRoutine;
      final routine = Routine(
        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        checklist: _checklist,
        date: _date,
        hour: _hour,
        minute: _minute,
        repeatWeekdays: _weekdays.toList()..sort(),
        tags: _selectedTags.toList(),
        lastDoneDate: existing?.lastDoneDate,
      );
      if (_isEdit) {
        await state.updateRoutine(routine);
      } else {
        await state.addRoutine(routine);
      }
    } else {
      final existing = widget.initialTodo;
      final todo = Todo(
        id: existing?.id ??
            '${DateTime.now().microsecondsSinceEpoch}_t',
        title: title,
        checklist: _checklist,
        date: _date,
        hour: _hour,
        minute: _minute,
        tags: _selectedTags.toList(),
        done: existing?.done ?? false,
        doneDate: existing?.doneDate,
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
    final customTags = context.watch<AppState>().customTags;
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final id in DefaultTags.all)
                      FilterChip(
                        label: Text(
                          _defaultTagLabel(l10n, id),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: _selectedTags.contains(id),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags = {..._selectedTags, id};
                            } else {
                              _selectedTags = {..._selectedTags}..remove(id);
                            }
                          });
                        },
                      ),
                    for (final tag in customTags)
                      FilterChip(
                        label: Text(
                          tag,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: _selectedTags.contains(tag),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags = {..._selectedTags, tag};
                            } else {
                              _selectedTags = {..._selectedTags}..remove(tag);
                            }
                          });
                        },
                      ),
                    ActionChip(
                      label: const Text('+'),
                      onPressed: _addCustomTag,
                    ),
                  ],
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
