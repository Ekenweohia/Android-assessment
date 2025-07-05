import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),  
      receiveTimeout: const Duration(seconds: 15),  
    ),
  )..interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
});
