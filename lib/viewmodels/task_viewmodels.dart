

import 'package:dio/dio.dart';
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


  bool _isLocal(Task task) => task.id > 150;

  Future<void> loadTasks() async {
    state = const TaskState.loading();
    try {
      final tasks = await _repo.getTasks();
      state = TaskState.data(tasks);
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  Future<void> toggleComplete(Task task) async {
    final current = state;
    if (current is Data) {
      
      state = TaskState.data(current.tasks.map((t) {
        if (t.id == task.id) {
          return task.copyWith(completed: !t.completed);
        }
        return t;
      }).toList());
    }

    try {
      
      if (!_isLocal(task)) {
        await _repo.toggleTaskComplete(task);
      }
    } on DioException catch (e) {
      
      if (e.response?.statusCode != 404) {
        state = TaskState.error(e.toString());
      }
    }
  }

  Future<void> addTask(String title) async {
    final current = state;
    state = const TaskState.loading();

    try {
      
      final newTask = await _repo.addTask(title);

     
      if (current is Data) {
        state = TaskState.data([newTask, ...current.tasks]);
      } else {
        state = TaskState.data([newTask]);
      }
    } catch (e) {
      state = TaskState.error(e.toString());
    }
  }

  Future<void> deleteTask(int id) async {
    final current = state;
    if (current is Data) {
      
      state = TaskState.data(
        current.tasks.where((t) => t.id != id).toList(),
      );
    }

    try {
      
      if (id <= 150) {
        await _repo.deleteTask(id);
      }
    } on DioException catch (e) {
      
      if (e.response?.statusCode != 404) {
        state = TaskState.error(e.toString());
      }
    }
  }
}

final taskVMProvider =
    StateNotifierProvider<TaskViewModel, TaskState>((ref) {
  final repo = ref.read(taskRepoProvider);
  return TaskViewModel(repo)..loadTasks();
});
