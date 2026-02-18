import 'package:flutter/material.dart';

import '../../../../core/constants/user_roles.dart';
import '../../domain/user_entity.dart';

class UserFormDialog extends StatefulWidget {
  const UserFormDialog({super.key, this.initial});

  final UserEntity? initial;

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  UserRole _role = UserRole.assistant;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _emailController = TextEditingController(text: widget.initial?.email ?? '');
    _role = widget.initial?.role ?? UserRole.assistant;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Usuario'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
              validator: (v) => (v == null || !v.contains('@')) ? 'Correo inválido' : null,
            ),
            DropdownButtonFormField<UserRole>(
              value: _role,
              items: UserRole.values
                  .map((role) => DropdownMenuItem(value: role, child: Text(role.value)))
                  .toList(),
              onChanged: (value) => setState(() => _role = value ?? UserRole.assistant),
              decoration: const InputDecoration(labelText: 'Rol'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            Navigator.pop(
              context,
              UserEntity(
                id: widget.initial?.id ?? 0,
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                role: _role,
                active: widget.initial?.active ?? true,
              ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
