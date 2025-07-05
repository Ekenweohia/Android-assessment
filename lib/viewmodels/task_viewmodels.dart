// lib/viewmodels/task_viewmodels.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Providers/repository_providers.dart';
import 'package:myapp/models/task.dart';
import 'package:myapp/repositories/task/task_repository.dart';

part 'task_viewmodels.freezed.dart';

@freezed
class TaskState with _$TaskState {
  const factory TaskState.idle()                 = Idle;
  const factory TaskState.loading()              = Loading;
  const factory TaskState.data(List<Task> tasks) = Data;
  const factory TaskState.error(String message)  = Error;
}

class TaskViewModel extends StateNotifier<TaskState> {
  TaskViewModel(this._repo) : super(const TaskState.idle());

  final TaskRepository _repo;

  /// Load all tasks from the server.
  Future<void> loadTasks() async {
    state = const TaskState.loading();
    try {
      final tasks = await _repo.getTasks();
      state = TaskState.data(tasks);
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  /// Optimistically toggle a task’s completed flag,
  /// then persist it to the server.
  Future<void> toggleComplete(Task task) async {
    final current = state;
    if (current is Data) {
      // immediately update UI
      state = TaskState.data(current.tasks.map((t) {
        if (t.id == task.id) {
          return t.copyWith(completed: !t.completed);
        }
        return t;
      }).toList());
    }
    try {
      await _repo.toggleTaskComplete(task);
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  /// Create a new task on the server, then prepend it locally.
  Future<void> addTask(String title) async {
    final current = state;
    state = const TaskState.loading();
    try {
      // 1) create on server
      final newTask = await _repo.addTask(title);
      // 2) merge into existing list
      if (current is Data) {
        state = TaskState.data([newTask, ...current.tasks]);
      } else {
        state = TaskState.data([newTask]);
      }
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  /// Delete locally (optimistic) and then on the server.
  Future<void> deleteTask(int id) async {
    final current = state;
    if (current is Data) {
      state = TaskState.data(
        current.tasks.where((t) => t.id != id).toList(),
      );
    }
    try {
      await _repo.deleteTask(id);
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }
}

final taskVMProvider =
    StateNotifierProvider<TaskViewModel, TaskState>((ref) {
  final repo = ref.read(taskRepoProvider);
  return TaskViewModel(repo)
    // load tasks as soon as the provider is created:
    ..loadTasks();
});
