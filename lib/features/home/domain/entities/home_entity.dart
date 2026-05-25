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

/// Matches the profile saved by ProfileSetupPage → profiles/{uid}
/// cycleDay and nextPeriodDate are computed fields also stored on the same doc.
// class UserProfileEntity extends Equatable {
//   final String uid;
//   final String name;
//   final String ageRange;
//   final String lifeStage; // "Period Tracking", "General Wellness", etc.
//   final List<String> conditions;
//   final String? medications;
//   // final int cycleDay;
//   // final DateTime nextPeriodDate;

//   const UserProfileEntity({
//     required this.uid,
//     required this.name,
//     required this.ageRange,
//     required this.lifeStage,
//     this.conditions = const [],
//     this.medications,
//     // required this.cycleDay,
//     // required this.nextPeriodDate,
//   });

//   /// Convenience: the home header shows lifeStage as the tracking badge.
//   String get trackingType => lifeStage;

//   /// Initials for the avatar circle.
//   String get shortName =>
//       name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'P';

//   @override
//   List<Object?> get props => [
//     uid,
//     name,
//     ageRange,
//     lifeStage,
//     conditions,
//     medications,
//     // cycleDay,
//     // nextPeriodDate,
//   ];
// }

class SymptomLogEntity extends Equatable {
  final String id;
  final DateTime date;
  final String periodStatus;
  final String flowLevel;
  final int painLevel;
  final String mood;
  final List<String> symptoms;
  final String? notes;

  const SymptomLogEntity({
    required this.id,
    required this.date,
    required this.periodStatus,
    required this.flowLevel,
    required this.painLevel,
    required this.mood,
    required this.symptoms,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    date,
    periodStatus,
    flowLevel,
    painLevel,
    mood,
    symptoms,
    notes,
  ];
}

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
