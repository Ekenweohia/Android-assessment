import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Providers/network_provider.dart';
import 'package:myapp/api/auth_api.dart';
import 'package:myapp/api/task_api.dart';



final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.read(dioProvider);
  return AuthApiImpl(dio);
});


final taskApiProvider = Provider<TaskApi>((ref) {
  final dio = ref.read(dioProvider);
  return TaskApiImpl(dio);
});