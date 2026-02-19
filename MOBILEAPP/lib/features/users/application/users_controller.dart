import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/user_entity.dart';
import '../domain/user_usecases.dart';

class UsersState {
  const UsersState({this.items = const [], this.loading = false, this.error});

  final List<UserEntity> items;
  final bool loading;
  final String? error;

  UsersState copyWith({List<UserEntity>? items, bool? loading, String? error}) {
    return UsersState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class UsersController extends StateNotifier<UsersState> {
  UsersController(this._listUsersUseCase, this._saveUserUseCase)
      : super(const UsersState());

  final ListUsersUseCase _listUsersUseCase;
  final SaveUserUseCase _saveUserUseCase;

  Future<void> loadUsers() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final items = await _listUsersUseCase.execute();
      state = state.copyWith(items: items, loading: false);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'No se pudieron cargar usuarios');
    }
  }

  Future<void> createUser(String name, String email, String role) async {
    await _saveUserUseCase.create(name, email, role);
    await loadUsers();
  }

  Future<void> updateUser(UserEntity user) async {
    await _saveUserUseCase.update(user.id, user.name, user.email, user.role, user.active);
    await loadUsers();
  }
}

final StateNotifierProvider<UsersController, UsersState> usersControllerProvider =
    StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController(
    ref.read(listUsersUseCaseProvider),
    ref.read(saveUserUseCaseProvider),
  );
});
