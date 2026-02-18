import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/patient_entity.dart';
import '../domain/patient_usecases.dart';

class PatientsState {
  const PatientsState({this.items = const [], this.loading = false, this.query = ''});

  final List<PatientEntity> items;
  final bool loading;
  final String query;

  PatientsState copyWith({List<PatientEntity>? items, bool? loading, String? query}) {
    return PatientsState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      query: query ?? this.query,
    );
  }
}

class PatientsController extends StateNotifier<PatientsState> {
  PatientsController(this._useCases) : super(const PatientsState());

  final PatientsUseCases _useCases;

  Future<void> load({String query = ''}) async {
    state = state.copyWith(loading: true, query: query);
    final items = await _useCases.list(query: query);
    state = state.copyWith(items: items, loading: false);
  }

  Future<void> create(PatientEntity patient) async {
    await _useCases.create(patient);
    await load(query: state.query);
  }

  Future<void> update(PatientEntity patient) async {
    await _useCases.update(patient);
    await load(query: state.query);
  }
}

final patientsControllerProvider =
    StateNotifierProvider<PatientsController, PatientsState>((ref) {
  return PatientsController(ref.read(patientsUseCasesProvider))..load();
});
