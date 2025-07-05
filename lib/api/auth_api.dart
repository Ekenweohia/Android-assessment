import 'package:dio/dio.dart';
import 'package:myapp/models/login_request.dart';
import 'package:myapp/models/login_response.dart';
import 'package:myapp/models/signup_request.dart';


class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

abstract class AuthApi {
  Future<LoginResponse> login(LoginRequest req, {int? expiresInMins});
  Future<LoginResponse> signup(SignupRequest req);
}

class AuthApiImpl implements AuthApi {
  AuthApiImpl(this._dio);
  final Dio _dio;

  @override
  Future<LoginResponse> login(LoginRequest req,
      {int? expiresInMins}) async {
    
    final body = req.toJson();
    if (expiresInMins != null) {
      body['expiresInMins'] = expiresInMins;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: body,
        options: Options(contentType: Headers.jsonContentType),
      );
      
      return LoginResponse.fromJson(response.data!);
    } on DioException catch (e) {
      
      if (e.response?.statusCode == 400 && e.response?.data is Map) {
        final msg = (e.response!.data as Map)['message'] as String?;
        throw AuthException(msg ?? 'Invalid username or password');
      }
      
      rethrow;
    }
  }

  @override
  Future<LoginResponse> signup(SignupRequest req) async {
   
    await _dio.post(
      '/users/add',
      data: req.toJson(),
      options: Options(contentType: Headers.jsonContentType),
    );
    
    return login(
      LoginRequest(username: req.username, password: req.password),
      expiresInMins: 30,
    );
  }
}
