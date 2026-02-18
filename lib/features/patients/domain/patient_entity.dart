class PatientEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String document;
  final String phone;

  const PatientEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.document,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';
}
