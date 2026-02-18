import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_user.dart';
import '../domain/auth_usecases.dart';

class AuthState {
  const AuthState({this.user, this.token, this.loading = false, this.error});

  final AuthUser? user;
  final String? token;
  final bool loading;
  final String? error;

  AuthState copyWith({
    AuthUser? user,
    String? token,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
    );
  }

  bool get isLoggedIn => user != null && token != null;
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._loginUseCase) : super(const AuthState());

  final LoginUseCase _loginUseCase;

  Future<bool> login(String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final response = await _loginUseCase.execute(email, password);
      state = AuthState(user: response.user, token: response.token);
      return true;
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Credenciales inválidas o servicio no disponible.',
      );
      return false;
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(loginUseCaseProvider));
});
