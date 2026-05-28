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

class InsightEntity extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String patternNoticed;
  final List<String> suggestedQuestions;
  final String whenToSeekCare;
  final DateTime generatedDate;

  const InsightEntity({
    required this.id,
    required this.title,
    required this.summary,
    required this.patternNoticed,
    required this.suggestedQuestions,
    required this.whenToSeekCare,
    required this.generatedDate,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    patternNoticed,
    suggestedQuestions,
    whenToSeekCare,
    generatedDate,
  ];
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
