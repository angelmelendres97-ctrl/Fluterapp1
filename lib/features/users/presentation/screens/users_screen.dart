import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/users_controller.dart';
import '../../domain/user_entity.dart';
import '../widgets/user_form_dialog.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<UserEntity>(context: context, builder: (_) => const UserFormDialog());
          if (result != null) {
            await ref.read(usersControllerProvider.notifier).save(result);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: users.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, index) {
            final user = data[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text('${user.email} - ${user.role.value}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    final updated = await showDialog<UserEntity>(
                      context: context,
                      builder: (_) => UserFormDialog(initial: user),
                    );
                    if (updated != null) {
                      await ref.read(usersControllerProvider.notifier).save(updated);
                    }
                  } else {
                    await ref.read(usersControllerProvider.notifier).deactivate(user.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'deactivate', child: Text('Desactivar')),
                ],
              ),
            );
          },
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
