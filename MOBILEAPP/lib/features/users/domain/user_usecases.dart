import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/user_repository_impl.dart';
import 'user_entity.dart';
import 'user_repository.dart';

class ListUsersUseCase {
  const ListUsersUseCase(this._repo);
  final UserRepository _repo;

  Future<List<UserEntity>> execute() => _repo.listUsers();
}

class SaveUserUseCase {
  const SaveUserUseCase(this._repo);
  final UserRepository _repo;

  Future<void> create(String name, String email, String role) =>
      _repo.createUser(name, email, role);

  Future<void> update(int id, String name, String email, String role, bool active) =>
      _repo.updateUser(id, name, email, role, active);
}

final listUsersUseCaseProvider = Provider((ref) => ListUsersUseCase(ref.read(userRepositoryProvider)));
final saveUserUseCaseProvider = Provider((ref) => SaveUserUseCase(ref.read(userRepositoryProvider)));
