import '../../../../core_import.dart';

class HomeDataDto {
  final UserProfileDto profile;
  final SymptomLogDto? recentLog;
  final HealthRecordDto? recentRecord;
  final InsightDto? latestInsight;
  final ReminderDto? reminder;

  HomeDataDto({
    required this.profile,
    this.recentLog,
    this.recentRecord,
    this.latestInsight,
    this.reminder,
  });

  HomeDataEntity toEntity() => HomeDataEntity(
    profile: profile.toEntity(),
    recentLog: recentLog?.toEntity(),
    recentRecord: recentRecord?.toEntity(),
    latestInsight: latestInsight?.toEntity(),
    reminder: reminder?.toEntity(),
  );
}

// SymptomLogDto is defined in:
// features/symptom/data/dto/symptom_log_dto.dart
// Do NOT re-declare it here — it is exported via core_import.dart.

/// Maps profiles/{uid} — matches ProfileSetupPage's saved structure.
class UserProfileDto {
  final String uid;
  final String name;
  final String ageRange;
  final String lifeStage;
  final List<String> conditions;
  final String? medications;

  UserProfileDto({
    required this.uid,
    required this.name,
    required this.ageRange,
    required this.lifeStage,
    required this.conditions,
    this.medications,
  });

  factory UserProfileDto.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfileDto(
      uid: uid,
      name: data['name'] as String? ?? '',
      ageRange: data['ageRange'] as String? ?? '',
      lifeStage: data['lifeStage'] as String? ?? 'General Wellness',
      conditions: List<String>.from(data['conditions'] as List? ?? []),
      medications: data['medications'] as String?,
    );
  }

  UserProfileEntity toEntity() => UserProfileEntity(
    uid: uid,
    name: name,
    ageRange: ageRange,
    lifeStage: lifeStage,
    conditions: conditions,
    medications: medications,
  );
}

class HealthRecordDto {
  final String id;
  final String title;
  final DateTime date;
  final String? doctorName;
  final String recordType;
  final String? notes;
  final String? fileUrl;

  HealthRecordDto({
    required this.id,
    required this.title,
    required this.date,
    this.doctorName,
    required this.recordType,
    this.notes,
    this.fileUrl,
  });

  factory HealthRecordDto.fromFirestore(Map<String, dynamic> data, String id) {
    return HealthRecordDto(
      id: id,
      title: data['title'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      doctorName: data['doctorName'] as String?,
      recordType: data['recordType'] as String? ?? 'Lab Report',
      notes: data['notes'] as String?,
      fileUrl: data['fileUrl'] as String?,
    );
  }

  HealthRecordEntity toEntity() => HealthRecordEntity(
    id: id,
    title: title,
    date: date,
    doctorName: doctorName,
    recordType: recordType,
    notes: notes,
    fileUrl: fileUrl,
  );
}

class InsightDto {
  final String id;
  final String title;
  final String body;
  final DateTime generatedDate;

  InsightDto({
    required this.id,
    required this.title,
    required this.body,
    required this.generatedDate,
  });

  factory InsightDto.fromFirestore(Map<String, dynamic> data, String id) {
    return InsightDto(
      id: id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      generatedDate:
          (data['generatedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  InsightEntity toEntity() => InsightEntity(
    id: id,
    title: title,
    body: body,
    generatedDate: generatedDate,
  );
}

class ReminderDto {
  final String id;
  final String title;
  final DateTime scheduledAt;

  ReminderDto({
    required this.id,
    required this.title,
    required this.scheduledAt,
  });

  factory ReminderDto.fromFirestore(Map<String, dynamic> data, String id) {
    return ReminderDto(
      id: id,
      title: data['title'] as String? ?? '',
      scheduledAt:
          (data['scheduledAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ReminderEntity toEntity() =>
      ReminderEntity(id: id, title: title, scheduledAt: scheduledAt);
}
