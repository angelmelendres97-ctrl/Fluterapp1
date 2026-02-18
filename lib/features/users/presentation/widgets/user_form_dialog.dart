import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../domain/user_entity.dart';

class UserFormDialog extends StatefulWidget {
  const UserFormDialog({required this.onSubmit, this.user, super.key});

  final UserEntity? user;
  final Future<void> Function(UserEntity user) onSubmit;

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  String _role = 'asistente';
  bool _active = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _emailController = TextEditingController(text: widget.user?.email);
    _role = widget.user?.role ?? 'asistente';
    _active = widget.user?.active ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.user == null ? 'Crear usuario' : 'Editar usuario'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Nombre',
              validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _emailController,
              label: 'Correo',
              validator: (v) => v == null || !v.contains('@') ? 'Correo inválido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                DropdownMenuItem(value: 'medico', child: Text('Médico')),
                DropdownMenuItem(value: 'asistente', child: Text('Asistente')),
              ],
              onChanged: (value) => setState(() => _role = value ?? 'asistente'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Activo'),
              value: _active,
              onChanged: (value) => setState(() => _active = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            await widget.onSubmit(
              UserEntity(
                id: widget.user?.id ?? 0,
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                role: _role,
                active: _active,
              ),
            );
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
