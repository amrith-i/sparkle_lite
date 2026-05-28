import '../../../../core_import.dart';

class DoctorVisitDto {
  final DateTime date;
  final String doctorName;
  final String? specialty;
  final String? clinic;
  final String diagnosis;
  final String? notes;

  const DoctorVisitDto({
    required this.date,
    required this.doctorName,
    this.specialty,
    this.clinic,
    required this.diagnosis,
    this.notes,
  });

  factory DoctorVisitDto.fromEntity(DoctorVisitEntity entity) {
    return DoctorVisitDto(
      date: entity.date,
      doctorName: entity.doctorName,
      specialty: entity.specialty,
      clinic: entity.clinic,
      diagnosis: entity.diagnosis,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'doctorName': doctorName,
      if (specialty != null && specialty!.isNotEmpty) 'specialty': specialty,
      if (clinic != null && clinic!.isNotEmpty) 'clinic': clinic,
      'diagnosis': diagnosis,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestoreForUpdate() {
    return {
      'date': Timestamp.fromDate(date),
      'doctorName': doctorName,
      'specialty': specialty != null && specialty!.isNotEmpty
          ? specialty
          : FieldValue.delete(),
      'clinic': clinic != null && clinic!.isNotEmpty
          ? clinic
          : FieldValue.delete(),
      'diagnosis': diagnosis,
      'notes': notes != null && notes!.isNotEmpty ? notes : FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
