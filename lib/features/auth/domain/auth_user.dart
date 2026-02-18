import '../../../core/constants/user_roles.dart';

class AuthUser {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String accessToken;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.accessToken,
  });
}
