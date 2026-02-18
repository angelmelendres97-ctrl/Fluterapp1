import 'package:dio/dio.dart';

import '../domain/patient_entity.dart';
import '../domain/patient_repository.dart';
import 'patient_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  PatientRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<PatientEntity>> listPatients({String query = ''}) async {
    final response = await _dio.get('/patients', queryParameters: {'query': query});
    final data = (response.data as List).cast<Map<String, dynamic>>();
    return data.map(PatientModel.fromJson).toList();
  }

  @override
  Future<void> savePatient(PatientEntity patient) async {
    await _dio.post('/patients', data: PatientModel(
      id: patient.id,
      firstName: patient.firstName,
      lastName: patient.lastName,
      document: patient.document,
      phone: patient.phone,
    ).toJson());
  }
}
