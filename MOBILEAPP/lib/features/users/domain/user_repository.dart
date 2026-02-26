import 'user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> listUsers();
  Future<void> createUser(String name, String email, String role);
  Future<void> updateUser(int id, String name, String email, String role, bool active);
}
