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
  Future<List<Task>> getTasks({int? limit, int? skip}) =>
      _api.fetchTasks(limit: limit, skip: skip);

  @override
  Future<Task> getTask(int id) => _api.fetchTask(id);

  @override
  Future<List<Task>> getTasksByUser(int userId) =>
      _api.fetchByUser(userId);

  @override
  Future<Task> getRandomTask() => _api.fetchRandom();

  @override
  Future<Task> toggleTaskComplete(Task task) {
    final updated = task.copyWith(completed: !task.completed);
    return _api.updateTask(updated);
  }

  @override
  Future<Task> addTask(String title) => _api.createTask(title);

  @override
  Future<Task> deleteTask(int id) => _api.deleteTask(id);
}
