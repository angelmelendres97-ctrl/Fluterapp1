import 'auth_user.dart';

class LoginResponse {
  const LoginResponse({required this.user, required this.token});

  final AuthUser user;
  final String token;
}

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
}
