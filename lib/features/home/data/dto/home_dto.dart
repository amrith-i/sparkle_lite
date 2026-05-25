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

class SymptomLogDto {
  final String id;
  final DateTime date;
  final String periodStatus;
  final String flowLevel;
  final int painLevel;
  final String mood;
  final List<String> symptoms;
  final String? notes;

  SymptomLogDto({
    required this.id,
    required this.date,
    required this.periodStatus,
    required this.flowLevel,
    required this.painLevel,
    required this.mood,
    required this.symptoms,
    this.notes,
  });

  factory SymptomLogDto.fromFirestore(Map<String, dynamic> data, String id) {
    return SymptomLogDto(
      id: id,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      periodStatus: data['periodStatus'] as String? ?? 'No period',
      flowLevel: data['flowLevel'] as String? ?? 'None',
      painLevel: data['painLevel'] as int? ?? 0,
      mood: data['mood'] as String? ?? 'Calm',
      symptoms: List<String>.from(data['symptoms'] as List? ?? []),
      notes: data['notes'] as String?,
    );
  }

  SymptomLogEntity toEntity() => SymptomLogEntity(
    id: id,
    date: date,
    periodStatus: periodStatus,
    flowLevel: flowLevel,
    painLevel: painLevel,
    mood: mood,
    symptoms: symptoms,
    notes: notes,
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
