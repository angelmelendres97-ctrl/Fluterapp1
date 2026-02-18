import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../data/user_repository_impl.dart';
import '../domain/user_entity.dart';
import '../domain/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(dioProvider));
});

final usersControllerProvider = StateNotifierProvider<UsersController, AsyncValue<List<UserEntity>>>((ref) {
  return UsersController(ref.watch(userRepositoryProvider))..load();
});

class UsersController extends StateNotifier<AsyncValue<List<UserEntity>>> {
  UsersController(this._repository) : super(const AsyncLoading());

  final UserRepository _repository;

  Future<void> load() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.listUsers);
  }

  Future<void> save(UserEntity user) async {
    await _repository.saveUser(user);
    await load();
  }

  Future<void> deactivate(int id) async {
    await _repository.deactivateUser(id);
    await load();
  }
}
