import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/economy.dart';
import '../l10n/app_localizations.dart';
import '../models/routine.dart';
import '../models/todo.dart';
import '../providers/app_state.dart';
import 'routine_form_screen.dart';

enum _HomeSegment { routine, todo }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeSegment _segment = _HomeSegment.routine;

  String? _formatTime(int? hour, int? minute) {
    if (hour == null || minute == null) return null;
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
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

  void _showGoldSnackBar(int amount) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.goldEarned(amount))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  l10n.goldAmount(state.gold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 120,
                height: 120,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      isDone: state.isRoutineDoneToday,
                      formatTime: _formatTime,
                      checklistProgress: (total) =>
                          l10n.checklistProgress(0, total),
                      onOpen: (routine) {
                        context.push(
                          '/item/form',
                          extra: ItemFormArgs(
                            type: FormItemType.routine,
                            routine: routine,
                          ),
                        );
                      },
                      onToggle: (routine, checked) async {
                        await state.toggleRoutineDone(routine.id);
                        if (checked) {
                          _showGoldSnackBar(Economy.routineCompleteGold);
                        }
                      },
                      onLongPress: (routine) {
                        _confirmDelete(
                          onConfirm: () => state.deleteRoutine(routine.id),
                        );
                      },
                    )
                  : _TodoList(
                      todos: state.todaysTodos,
                      emptyHint: l10n.emptyTodosHint,
                      formatTime: _formatTime,
                      checklistProgress: (total) =>
                          l10n.checklistProgress(0, total),
                      onOpen: (todo) {
                        context.push(
                          '/item/form',
                          extra: ItemFormArgs(
                            type: FormItemType.todo,
                            todo: todo,
                          ),
                        );
                      },
                      onToggle: (todo, checked) async {
                        await state.toggleTodoDone(todo.id);
                        if (checked) {
                          _showGoldSnackBar(Economy.todoCompleteGold);
                        }
                      },
                      onLongPress: (todo) {
                        _confirmDelete(
                          onConfirm: () => state.deleteTodo(todo.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RoutineList extends StatelessWidget {
  const _RoutineList({
    required this.routines,
    required this.emptyHint,
    required this.isDone,
    required this.formatTime,
    required this.checklistProgress,
    required this.onOpen,
    required this.onToggle,
    required this.onLongPress,
  });

  final List<Routine> routines;
  final String emptyHint;
  final bool Function(Routine) isDone;
  final String? Function(int?, int?) formatTime;
  final String Function(int total) checklistProgress;
  final void Function(Routine routine) onOpen;
  final void Function(Routine routine, bool checked) onToggle;
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
        final time = formatTime(routine.hour, routine.minute);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: done,
                onChanged: (value) => onToggle(routine, value ?? false),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onOpen(routine),
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
                        if (routine.checklist.isNotEmpty)
                          Text(
                            checklistProgress(routine.checklist.length),
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (time != null)
                          Text(
                            time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
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
    required this.formatTime,
    required this.checklistProgress,
    required this.onOpen,
    required this.onToggle,
    required this.onLongPress,
  });

  final List<Todo> todos;
  final String emptyHint;
  final String? Function(int?, int?) formatTime;
  final String Function(int total) checklistProgress;
  final void Function(Todo todo) onOpen;
  final void Function(Todo todo, bool checked) onToggle;
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
        final time = formatTime(todo.hour, todo.minute);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: todo.done,
                onChanged: (value) => onToggle(todo, value ?? false),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onOpen(todo),
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
                        if (todo.checklist.isNotEmpty)
                          Text(
                            checklistProgress(todo.checklist.length),
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (time != null)
                          Text(
                            time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
