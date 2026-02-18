import 'patient_entity.dart';

abstract class PatientRepository {
  Future<List<PatientEntity>> listPatients({String query = ''});
  Future<void> savePatient(PatientEntity patient);
}
