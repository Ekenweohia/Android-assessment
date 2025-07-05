import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Providers/api_providers.dart';
import 'package:myapp/repositories/auth/auth_repository.dart';
import 'package:myapp/repositories/task/task_repository.dart';

final dioProvider = Provider<Dio>((_) => Dio(
  BaseOptions(baseUrl: 'https://dummyjson.com'),
));

final authRepoProvider = Provider<AuthRepository>((ref) {
  final api = ref.read(authApiProvider);
  return AuthRepositoryImpl(api);
});

final taskRepoProvider = Provider<TaskRepository>((ref) {
  final api = ref.read(taskApiProvider);
  return TaskRepositoryImpl(api);
});
