import '../domain/auth_user.dart';

class AuthState {
  final bool isLoading;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.user, this.errorMessage});

  bool get isAuthenticated => user != null;

  AuthState copyWith({bool? isLoading, AuthUser? user, String? errorMessage, bool clearError = false}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
