import '../../../../core_import.dart';

class HomeDataEntity extends Equatable {
  final UserProfileEntity profile;
  final SymptomLogEntity? recentLog;
  final HealthRecordEntity? recentRecord;
  final InsightEntity? latestInsight;
  final ReminderEntity? reminder;

  const HomeDataEntity({
    required this.profile,
    this.recentLog,
    this.recentRecord,
    this.latestInsight,
    this.reminder,
  });

  @override
  List<Object?> get props => [
    profile,
    recentLog,
    recentRecord,
    latestInsight,
    reminder,
  ];
}

// SymptomLogEntity is defined in:
// features/symptom/domain/entities/symptom_log_entity.dart
// Do NOT re-declare it here — it is exported via core_import.dart.

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

class InsightEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime generatedDate;

  const InsightEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.generatedDate,
  });

  @override
  List<Object?> get props => [id, title, body, generatedDate];
}

class ReminderEntity extends Equatable {
  final String id;
  final String title;
  final DateTime scheduledAt;

  const ReminderEntity({
    required this.id,
    required this.title,
    required this.scheduledAt,
  });

  @override
  List<Object?> get props => [id, title, scheduledAt];
}
