class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.active,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final bool active;
}
