import 'patient_entity.dart';

abstract class PatientRepository {
  Future<List<PatientEntity>> listPatients({String query = ''});
  Future<PatientEntity> getPatientById(int id);
  Future<void> createPatient(PatientEntity patient);
  Future<void> updatePatient(PatientEntity patient);
}
