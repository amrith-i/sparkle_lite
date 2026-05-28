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

class InsightDto {
  final String id;
  final String title;
  final String summary;
  final String patternNoticed;
  final List<String> suggestedQuestions;
  final String whenToSeekCare;
  final DateTime generatedDate;

  InsightDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.patternNoticed,
    required this.suggestedQuestions,
    required this.whenToSeekCare,
    required this.generatedDate,
  });

  factory InsightDto.fromFirestore(Map<String, dynamic> data, String id) {
    return InsightDto(
      id: id,
      title: data['title'] as String? ?? 'AI Health Insight',
      summary: data['summary'] as String? ?? '',
      patternNoticed: data['patternNoticed'] as String? ?? '',
      suggestedQuestions: List<String>.from(
        data['suggestedQuestions'] as List? ?? [],
      ),
      whenToSeekCare: data['whenToSeekCare'] as String? ?? '',
      generatedDate:
          (data['generatedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'summary': summary,
      'patternNoticed': patternNoticed,
      'suggestedQuestions': suggestedQuestions,
      'whenToSeekCare': whenToSeekCare,
      'generatedDate': Timestamp.fromDate(generatedDate),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  InsightEntity toEntity() {
    return InsightEntity(
      id: id,
      title: title,
      summary: summary,
      patternNoticed: patternNoticed,
      suggestedQuestions: suggestedQuestions,
      whenToSeekCare: whenToSeekCare,
      generatedDate: generatedDate,
    );
  }
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
