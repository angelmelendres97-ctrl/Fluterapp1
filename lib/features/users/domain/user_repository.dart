import 'user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> listUsers();
  Future<void> saveUser(UserEntity user);
  Future<void> deactivateUser(int id);
}
