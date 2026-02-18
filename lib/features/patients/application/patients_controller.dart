import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../data/patient_repository_impl.dart';
import '../domain/patient_entity.dart';
import '../domain/patient_repository.dart';

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepositoryImpl(ref.watch(dioProvider));
});

final patientsQueryProvider = StateProvider<String>((ref) => '');

final patientsControllerProvider = StateNotifierProvider<PatientsController, AsyncValue<List<PatientEntity>>>((ref) {
  return PatientsController(ref.watch(patientRepositoryProvider), ref)..load();
});

class PatientsController extends StateNotifier<AsyncValue<List<PatientEntity>>> {
  PatientsController(this._repository, this._ref) : super(const AsyncLoading());

  final PatientRepository _repository;
  final Ref _ref;

  Future<void> load() async {
    final query = _ref.read(patientsQueryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.listPatients(query: query));
  }

  Future<void> search(String query) async {
    _ref.read(patientsQueryProvider.notifier).state = query;
    await load();
  }

  Future<void> save(PatientEntity patient) async {
    await _repository.savePatient(patient);
    await load();
  }
}
