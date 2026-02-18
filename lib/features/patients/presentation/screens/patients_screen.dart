import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/patients_controller.dart';
import '../../domain/patient_entity.dart';
import '../widgets/patient_form_dialog.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(patientsControllerProvider);
    final controller = ref.read(patientsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de pacientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => PatientFormDialog(onSubmit: controller.create),
        ),
        label: const Text('Nuevo paciente'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar por nombre o documento',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.load(query: value),
            ),
          ),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (_, index) {
                      final PatientEntity patient = state.items[index];
                      return ListTile(
                        title: Text(patient.fullName),
                        subtitle: Text('${patient.document} · ${patient.phone}'),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PatientDetailScreen(patient: patient),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) => PatientFormDialog(
                              patient: patient,
                              onSubmit: controller.update,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({required this.patient, super.key});

  final PatientEntity patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de paciente')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(patient.fullName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text('Documento: ${patient.document}'),
          Text('Teléfono: ${patient.phone}'),
          Text('Email: ${patient.email}'),
        ],
      ),
    );
  }
}
