import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/viewmodels/task_viewmodels.dart';

class AnimatedTaskList extends ConsumerStatefulWidget {
  const AnimatedTaskList({super.key});

  @override
  ConsumerState<AnimatedTaskList> createState() => _AnimatedTaskListState();
}

class _AnimatedTaskListState extends ConsumerState<AnimatedTaskList> {
  final _listKey = GlobalKey<AnimatedListState>();
  List<Task> _oldTasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newState = ref.watch(taskVMProvider);
    newState.maybeWhen(
      data: (newTasks) {
        _updateList(newTasks);
        _oldTasks = List.from(newTasks);
      },
      orElse: () {},
    );
  }

  void _updateList(List<Task> newTasks) {
    final insertions = <int>[];
    final removals   = <int>[];

    for (int i = 0; i < _oldTasks.length; i++) {
      if (!newTasks.any((t) => t.id == _oldTasks[i].id)) {
        removals.add(i);
      }
    }
  
    for (int i = 0; i < newTasks.length; i++) {
      if (!_oldTasks.any((t) => t.id == newTasks[i].id)) {
        insertions.add(i);
      }
    }

    for (var i in removals.reversed) {
      _listKey.currentState?.removeItem(
        i,
        (ctx, anim) => SizeTransition(
          sizeFactor: anim,
          child: _buildTaskCard(_oldTasks[i]),
        ),
        duration: const Duration(milliseconds: 300),
      );
    }

    for (var i in insertions) {
      _listKey.currentState?.insertItem(
        i,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskVMProvider).maybeWhen(
          data: (t) => t,
          orElse: () => const <Task>[],
        );

    return AnimatedList(
      key: _listKey,
      initialItemCount: tasks.length,
      itemBuilder: (ctx, i, anim) => SizeTransition(
        sizeFactor: anim,
        child: _buildTaskCard(tasks[i]),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          title: Text(task.title),
          leading: Checkbox(
            value: task.completed,
            onChanged: (_) =>
                ref.read(taskVMProvider.notifier).toggleComplete(task),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () =>
                ref.read(taskVMProvider.notifier).deleteTask(task.id),
          ),
        ),
      ),
    );
  }
}
