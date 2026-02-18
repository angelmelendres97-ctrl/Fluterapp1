import 'package:dio/dio.dart';

import '../domain/user_entity.dart';
import '../domain/user_repository.dart';
import 'user_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<void> deactivateUser(int id) async {
    await _dio.delete('/users/$id');
  }

  @override
  Future<List<UserEntity>> listUsers() async {
    final response = await _dio.get('/users');
    final items = (response.data as List).cast<Map<String, dynamic>>();
    return items.map(UserModel.fromJson).toList();
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    await _dio.post('/users', data: UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      active: user.active,
    ).toJson());
  }
}
