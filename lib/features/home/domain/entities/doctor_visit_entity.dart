import '../../../../core_import.dart';

class DoctorVisitEntity extends Equatable {
  final String? id; // Optional: for editing existing visits
  final DateTime date;
  final String doctorName;
  final String? specialty;
  final String? clinic;
  final String diagnosis;
  final String? notes;

  const DoctorVisitEntity({
    this.id,
    required this.date,
    required this.doctorName,
    this.specialty,
    this.clinic,
    required this.diagnosis,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    doctorName,
    specialty,
    clinic,
    diagnosis,
    notes,
  ];
}
