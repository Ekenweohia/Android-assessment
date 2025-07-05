import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Providers/repository_providers.dart';
import 'package:myapp/api/auth_api.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/repositories/auth/auth_repository.dart';

part 'auth_viewmodels.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.idle()             = Idle;
  const factory AuthState.loading()          = Loading;
  const factory AuthState.success(User user) = Success;
  const factory AuthState.error(String msg)  = Error;
}

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._repo) : super(const AuthState.idle());
  final AuthRepository _repo;

 
  Future<void> login(String username, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repo.login(username, password);
      state = AuthState.success(user);
    } catch (e) {
 
      final msg = e is AuthException
        ? e.message
        : 'Something went wrong. Please try again.';
      state = AuthState.error(msg);
    }
  }


  Future<void> signup(String username, String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repo.signup(username, email, password);
      state = AuthState.success(user);
    } catch (e) {
      final msg = e is AuthException
        ? e.message
        : 'Something went wrong. Please try again.';
      state = AuthState.error(msg);
    }
  }
}

final authVMProvider =
    StateNotifierProvider<AuthViewModel, AuthState>(
  (ref) => AuthViewModel(ref.read(authRepoProvider)),
);
