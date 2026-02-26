import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../domain/patient_entity.dart';

class PatientFormDialog extends StatefulWidget {
  const PatientFormDialog({required this.onSubmit, this.patient, super.key});

  final PatientEntity? patient;
  final Future<void> Function(PatientEntity patient) onSubmit;

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _document;
  late final TextEditingController _phone;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.patient?.firstName);
    _lastName = TextEditingController(text: widget.patient?.lastName);
    _document = TextEditingController(text: widget.patient?.document);
    _phone = TextEditingController(text: widget.patient?.phone);
    _email = TextEditingController(text: widget.patient?.email);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.patient == null ? 'Registrar paciente' : 'Editar paciente'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _firstName,
                label: 'Nombres',
                validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _lastName,
                label: 'Apellidos',
                validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _document,
                label: 'Documento',
                validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(controller: _phone, label: 'Teléfono'),
              const SizedBox(height: 12),
              AppTextField(
                controller: _email,
                label: 'Email',
                validator: (value) => value == null || !value.contains('@') ? 'Correo inválido' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            await widget.onSubmit(
              PatientEntity(
                id: widget.patient?.id ?? 0,
                firstName: _firstName.text.trim(),
                lastName: _lastName.text.trim(),
                document: _document.text.trim(),
                phone: _phone.text.trim(),
                email: _email.text.trim(),
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
