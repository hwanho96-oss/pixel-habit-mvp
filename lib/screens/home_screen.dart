import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/economy.dart';
import '../l10n/app_localizations.dart';
import '../models/routine.dart';
import '../models/todo.dart';
import '../providers/app_state.dart';

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

  Future<void> _showAddDialog(AppState state) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.addDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.addDialogHint),
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
    if (title == null || title.isEmpty) return;

    if (_segment == _HomeSegment.routine) {
      await state.addRoutine(title);
    } else {
      await state.addTodo(title);
    }
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
              child: Row(
                children: [
                  const Spacer(),
                  Flexible(
                    child: Text(
                      l10n.goldAmount(state.gold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
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
                      isDone: state.isRoutineDoneToday,
                      formatTime: _formatTime,
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
                      formatTime: _formatTime,
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
        onPressed: () => _showAddDialog(state),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _RoutineList extends StatelessWidget {
  const _RoutineList({
    required this.routines,
    required this.isDone,
    required this.formatTime,
    required this.onToggle,
    required this.onLongPress,
  });

  final List<Routine> routines;
  final bool Function(Routine) isDone;
  final String? Function(int?, int?) formatTime;
  final void Function(Routine routine, bool checked) onToggle;
  final void Function(Routine routine) onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: routines.length,
      itemBuilder: (context, index) {
        final routine = routines[index];
        final done = isDone(routine);
        final time = formatTime(routine.hour, routine.minute);
        return InkWell(
          onLongPress: () => onLongPress(routine),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: done,
                  onChanged: (value) => onToggle(routine, value ?? false),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.title,
                        softWrap: true,
                        maxLines: 3,
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    required this.todos,
    required this.formatTime,
    required this.onToggle,
    required this.onLongPress,
  });

  final List<Todo> todos;
  final String? Function(int?, int?) formatTime;
  final void Function(Todo todo, bool checked) onToggle;
  final void Function(Todo todo) onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        final time = formatTime(todo.hour, todo.minute);
        return InkWell(
          onLongPress: () => onLongPress(todo),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: todo.done,
                  onChanged: (value) => onToggle(todo, value ?? false),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        softWrap: true,
                        maxLines: 3,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
