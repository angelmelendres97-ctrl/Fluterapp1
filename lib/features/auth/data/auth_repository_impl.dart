import 'package:dio/dio.dart';

import '../../../core/constants/user_roles.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});
      final data = response.data as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>;
      return AuthUser(
        id: user['id'].toString(),
        email: user['email'] as String,
        name: user['name'] as String,
        role: UserRoleX.fromString(user['role'] as String),
        accessToken: data['accessToken'] as String,
      );
    } on DioException catch (e) {
      throw AppException(e.response?.data['message']?.toString() ?? 'Error al iniciar sesión');
    }
  }

  @override
  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}
