import '../../../../core_import.dart';

class HealthRecordEntity extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final String? doctorName;
  final String recordType;
  final String? notes;
  final String? fileUrl;

  const HealthRecordEntity({
    required this.id,
    required this.title,
    required this.date,
    this.doctorName,
    required this.recordType,
    this.notes,
    this.fileUrl,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    date,
    doctorName,
    recordType,
    notes,
    fileUrl,
  ];
}
// SymptomLogEntity is defined in:
//   features/symptom/domain/entities/symptom_log_entity.dart
// Do NOT re-declare it here — it is exported via core_import.dart.

// class InsightEntity extends Equatable {
//   final String id;
//   final String title;
//   final String body;
//   final DateTime generatedDate;

//   const InsightEntity({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.generatedDate,
//   });

//   @override
//   List<Object?> get props => [id, title, body, generatedDate];
// }

// class ReminderEntity extends Equatable {
//   final String id;
//   final String title;
//   final DateTime scheduledAt;

//   const ReminderEntity({
//     required this.id,
//     required this.title,
//     required this.scheduledAt,
//   });

//   @override
//   List<Object?> get props => [id, title, scheduledAt];
// }
