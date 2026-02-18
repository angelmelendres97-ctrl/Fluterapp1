import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/users_controller.dart';
import '../../domain/user_entity.dart';
import '../widgets/user_form_dialog.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersControllerProvider);
    final controller = ref.read(usersControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de usuarios')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) => UserFormDialog(
              onSubmit: (user) => controller.createUser(user.name, user.email, user.role),
            ),
          );
        },
        label: const Text('Nuevo usuario'),
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(state.error!))
              : ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (_, index) {
                    final UserEntity user = state.items[index];
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text('${user.email} · ${user.role}'),
                      trailing: Icon(
                        user.active ? Icons.check_circle : Icons.cancel,
                        color: user.active ? Colors.green : Colors.red,
                      ),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (_) => UserFormDialog(
                            user: user,
                            onSubmit: controller.updateUser,
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
