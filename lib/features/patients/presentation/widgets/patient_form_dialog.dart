import 'package:flutter/material.dart';

import '../../domain/patient_entity.dart';

class PatientFormDialog extends StatefulWidget {
  const PatientFormDialog({super.key, this.initial});

  final PatientEntity? initial;

  @override
  State<PatientFormDialog> createState() => _PatientFormDialogState();
}

class _PatientFormDialogState extends State<PatientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _documentController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.initial?.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.initial?.lastName ?? '');
    _documentController = TextEditingController(text: widget.initial?.document ?? '');
    _phoneController = TextEditingController(text: widget.initial?.phone ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Paciente'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Apellido')),
              TextFormField(controller: _documentController, decoration: const InputDecoration(labelText: 'Documento')),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Teléfono')),
            ],
          ),
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
              PatientEntity(
                id: widget.initial?.id ?? 0,
                firstName: _firstNameController.text.trim(),
                lastName: _lastNameController.text.trim(),
                document: _documentController.text.trim(),
                phone: _phoneController.text.trim(),
              ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
