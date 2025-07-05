import 'package:myapp/api/auth_api.dart';
import 'package:myapp/models/login_request.dart';
import 'package:myapp/models/signup_request.dart';
import 'package:myapp/models/user.dart';


abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User> signup(String username, String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);
  final AuthApi _api;

  @override
  Future<User> login(String username, String password) async {
    final resp = await _api.login(
      LoginRequest(username: username, password: password),
      expiresInMins: 30,
    );
    return User(
      id: resp.id.toString(),
      username: resp.username,
      email: resp.email,
      firstName: resp.firstName,
      lastName: resp.lastName,
      gender: resp.gender,
      image: resp.image,
      accessToken: resp.accessToken,
      refreshToken: resp.refreshToken,
    );
  }

  @override
  Future<User> signup(String username, String email, String password) async {
    final resp = await _api.signup(
      SignupRequest(username: username, email: email, password: password),
    );
    return User(
      id: resp.id.toString(),
      username: resp.username,
      email: resp.email,
      firstName: resp.firstName,
      lastName: resp.lastName,
      gender: resp.gender,
      image: resp.image,
      accessToken: resp.accessToken,
      refreshToken: resp.refreshToken,
    );
  }
}
