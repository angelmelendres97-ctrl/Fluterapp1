enum UserRole { admin, doctor, assistant }

extension UserRoleX on UserRole {
  String get value => switch (this) {
        UserRole.admin => 'ADMIN',
        UserRole.doctor => 'DOCTOR',
        UserRole.assistant => 'ASSISTANT',
      };

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value.toUpperCase(),
      orElse: () => UserRole.assistant,
    );
  }
}
