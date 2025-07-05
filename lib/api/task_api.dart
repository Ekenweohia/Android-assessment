import 'package:dio/dio.dart';
import 'package:myapp/models/task.dart';


abstract class TaskApi {
  Future<List<Task>> fetchTasks({int? limit, int? skip});
  Future<Task> fetchTask(int id);
  Future<List<Task>> fetchByUser(int userId);
  Future<Task> fetchRandom();
  Future<Task> updateTask(Task task);
  Future<Task> createTask(String title, {int userId});
  Future<Task> deleteTask(int id);
}

class TaskApiImpl implements TaskApi {
  TaskApiImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<Task>> fetchTasks({int? limit, int? skip}) async {
    final resp = await _dio.get<Map<String, dynamic>>(
      '/todos',
      queryParameters: {
        if (limit != null) 'limit': limit,
        if (skip  != null) 'skip': skip,
      },
    );
    final todos = resp.data!['todos'] as List<dynamic>;
    return todos
        .cast<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList();
  }

  @override
  Future<Task> fetchTask(int id) async {
    final resp = await _dio.get<Map<String, dynamic>>('/todos/$id');
    return Task.fromJson(resp.data!);
  }

  @override
  Future<List<Task>> fetchByUser(int userId) async {
    final resp = await _dio.get<Map<String, dynamic>>('/todos/user/$userId');
    final todos = resp.data!['todos'] as List<dynamic>;
    return todos
        .cast<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList();
  }

  @override
  Future<Task> fetchRandom() async {
    final resp = await _dio.get<Map<String, dynamic>>('/todos/random');
    return Task.fromJson(resp.data!);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final resp = await _dio.patch<Map<String, dynamic>>(
      '/todos/${task.id}',
      data: {'completed': task.completed},
      options: Options(contentType: Headers.jsonContentType),
    );
    return Task.fromJson(resp.data!);
  }

  @override
  Future<Task> createTask(String title, {int userId = 5}) async {
    
    final resp = await _dio.post<Map<String, dynamic>>(
      '/todos/add',
      data: {
        'todo': title,
        'completed': false,
        'userId': userId,
      },
      options: Options(contentType: Headers.jsonContentType),
    );
    return Task.fromJson(resp.data!);
  }

  @override
  Future<Task> deleteTask(int id) async {
    final resp = await _dio.delete<Map<String, dynamic>>('/todos/$id');
    return Task.fromJson(resp.data!);
  }
}
