import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/patients_controller.dart';
import '../../domain/patient_entity.dart';
import '../widgets/patient_form_dialog.dart';

class PatientsScreen extends ConsumerWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Pacientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<PatientEntity>(context: context, builder: (_) => const PatientFormDialog());
          if (result != null) {
            await ref.read(patientsControllerProvider.notifier).save(result);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar paciente',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: ref.read(patientsControllerProvider.notifier).search,
            ),
          ),
          Expanded(
            child: patients.when(
              data: (data) => ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final p = data[i];
                  return ListTile(
                    title: Text(p.fullName),
                    subtitle: Text('Doc: ${p.document} - Tel: ${p.phone}'),
                  );
                },
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
