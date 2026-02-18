import '../../../core/constants/user_roles.dart';

class UserEntity {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final bool active;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.active,
  });
}
