import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../domain/patient_entity.dart';
import '../domain/patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  PatientRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<void> createPatient(PatientEntity patient) async {
    await _dio.post('/patients', data: _toJson(patient));
  }

  @override
  Future<PatientEntity> getPatientById(int id) async {
    final response = await _dio.get('/patients/$id');
    return _fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<PatientEntity>> listPatients({String query = ''}) async {
    final response = await _dio.get('/patients', queryParameters: {'q': query});
    final rows = response.data as List<dynamic>;
    return rows.map((row) => _fromJson(row as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> updatePatient(PatientEntity patient) async {
    await _dio.put('/patients/${patient.id}', data: _toJson(patient));
  }

  PatientEntity _fromJson(Map<String, dynamic> json) {
    return PatientEntity(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      document: json['document'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> _toJson(PatientEntity patient) {
    return {
      'firstName': patient.firstName,
      'lastName': patient.lastName,
      'document': patient.document,
      'phone': patient.phone,
      'email': patient.email,
    };
  }
}

final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepositoryImpl(ref.read(dioProvider));
});
