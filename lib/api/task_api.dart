// lib/api/task_api.dart

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

  // Helper to catch any non-2xx and rethrow as our own Exception:
  Future<T> _safeCall<T>(Future<Response<T>> future) async {
    final resp = await future;
    if (resp.statusCode != null && resp.statusCode! >= 200 && resp.statusCode! < 300) {
      return resp.data!;
    }
    throw DioException(
      requestOptions: resp.requestOptions,
      response: resp,
      error: 'API error: ${resp.statusCode}',
    );
  }

  @override
  Future<List<Task>> fetchTasks({int? limit, int? skip}) async {
    final resp = await _safeCall<Map<String, dynamic>>(
      _dio.get(
        '/todos',
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (skip  != null) 'skip': skip,
        },
      ),
    );
    final list = (resp['todos'] as List).cast<Map<String, dynamic>>();
    return list.map(Task.fromJson).toList();
  }

  @override
  Future<Task> fetchTask(int id) =>
    _safeCall<Map<String, dynamic>>(_dio.get('/todos/$id'))
      .then((json) => Task.fromJson(json));

  @override
  Future<List<Task>> fetchByUser(int userId) async {
    final resp = await _safeCall<Map<String, dynamic>>(
      _dio.get('/todos/user/$userId'),
    );
    final list = (resp['todos'] as List).cast<Map<String, dynamic>>();
    return list.map(Task.fromJson).toList();
  }

  @override
  Future<Task> fetchRandom() =>
    _safeCall<Map<String, dynamic>>(_dio.get('/todos/random'))
      .then(Task.fromJson);

  @override
  Future<Task> updateTask(Task task) =>
    _safeCall<Map<String, dynamic>>(
      _dio.patch(
        '/todos/${task.id}',
        data: {'completed': task.completed},
        options: Options(contentType: Headers.jsonContentType),
      ),
    ).then(Task.fromJson);

  @override
  Future<Task> createTask(String title, {int userId = 1}) =>
    _safeCall<Map<String, dynamic>>(
      _dio.post(
        '/todos/add',
        data: {
          'todo': title,
          'completed': false,
          'userId': userId,
        },
        options: Options(contentType: Headers.jsonContentType),
      ),
    ).then(Task.fromJson);

  @override
  Future<Task> deleteTask(int id) =>
    _safeCall<Map<String, dynamic>>(_dio.delete('/todos/$id'))
      .then(Task.fromJson);
}
