class PatientEntity {
  const PatientEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.document,
    required this.phone,
    required this.email,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String document;
  final String phone;
  final String email;

  String get fullName => '$firstName $lastName';
}
