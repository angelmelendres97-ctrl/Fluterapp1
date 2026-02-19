import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../domain/user_entity.dart';
import '../domain/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> createUser(String name, String email, String role) async {
    await _dio.post('/users', data: {'name': name, 'email': email, 'role': role});
  }

  @override
  Future<List<UserEntity>> listUsers() async {
    final response = await _dio.get('/users');
    final list = (response.data as List<dynamic>);
    return list
        .map((item) => UserEntity(
              id: item['id'] as int,
              name: item['name'] as String,
              email: item['email'] as String,
              role: item['role'] as String,
              active: item['active'] as bool,
            ))
        .toList();
  }

  @override
  Future<void> updateUser(
    int id,
    String name,
    String email,
    String role,
    bool active,
  ) async {
    await _dio.put('/users/$id', data: {
      'name': name,
      'email': email,
      'role': role,
      'active': active,
    });
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(dioProvider));
});
