import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    final userData = response.data['user'] as Map<String, dynamic>;
    return LoginResponse(
      token: response.data['accessToken'] as String,
      user: AuthUser(
        id: userData['id'].toString(),
        name: userData['name'] as String,
        email: userData['email'] as String,
        role: _parseRole(userData['role'] as String),
      ),
    );
  }

  UserRole _parseRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'medico':
        return UserRole.medico;
      default:
        return UserRole.asistente;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(dioProvider));
});
