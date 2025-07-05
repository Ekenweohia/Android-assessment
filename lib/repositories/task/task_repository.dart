import 'package:myapp/api/task_api.dart';
import 'package:myapp/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({int? limit, int? skip});
  Future<Task> getTask(int id);
  Future<List<Task>> getTasksByUser(int userId);
  Future<Task> getRandomTask();
  Future<Task> toggleTaskComplete(Task task);
  Future<Task> addTask(String title);
  Future<Task> deleteTask(int id);
}

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._api);
  final TaskApi _api;

  @override
  Future<List<Task>> getTasks({int? limit, int? skip}) {
    return _api.fetchTasks(limit: limit, skip: skip);
  }

  @override
  Future<Task> getTask(int id) {
    return _api.fetchTask(id);
  }

  @override
  Future<List<Task>> getTasksByUser(int userId) {
    return _api.fetchByUser(userId);
  }

  @override
  Future<Task> getRandomTask() {
    return _api.fetchRandom();
  }

  @override
  Future<Task> toggleTaskComplete(Task task) {
    // flip the boolean locally, then send the change up
    final updated = task.copyWith(completed: !task.completed);
    return _api.updateTask(updated);
  }

  @override
  Future<Task> addTask(String title) {
    // Note: createTask takes an optional userId, but the repository
    // interface just asks for a title.
    return _api.createTask(title);
  }

  @override
  Future<Task> deleteTask(int id) {
    return _api.deleteTask(id);
  }
}
