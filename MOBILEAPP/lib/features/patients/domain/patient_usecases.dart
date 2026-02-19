import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/patient_repository_impl.dart';
import 'patient_entity.dart';
import 'patient_repository.dart';

class PatientsUseCases {
  const PatientsUseCases(this._repository);

  final PatientRepository _repository;

  Future<List<PatientEntity>> list({String query = ''}) =>
      _repository.listPatients(query: query);

  Future<PatientEntity> detail(int id) => _repository.getPatientById(id);

  Future<void> create(PatientEntity patient) => _repository.createPatient(patient);

  Future<void> update(PatientEntity patient) => _repository.updatePatient(patient);
}

final patientsUseCasesProvider = Provider((ref) => PatientsUseCases(ref.read(patientRepositoryProvider)));
