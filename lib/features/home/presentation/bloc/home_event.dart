import '../../../../core_import.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHome extends HomeEvent {
  final String userId;

  const LoadHome({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshHome extends HomeEvent {
  final String userId;

  const RefreshHome({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SubmitSymptom extends HomeEvent {
  final String userId;
  final AddSymptomEntity entity;

  /// When non-null, the existing log at this Firestore document ID is
  /// **updated**. When null, a new document is created.
  final String? logId;

  const SubmitSymptom({required this.userId, required this.entity, this.logId});

  @override
  List<Object?> get props => [userId, entity, logId];
}

class SubmitUploadRecord extends HomeEvent {
  final String userId;
  final UploadRecordEntity entity;

  const SubmitUploadRecord({required this.userId, required this.entity});

  @override
  List<Object?> get props => [userId, entity];
}

class SubmitDoctorVisit extends HomeEvent {
  final String userId;
  final DoctorVisitEntity entity;

  const SubmitDoctorVisit({required this.userId, required this.entity});

  @override
  List<Object?> get props => [userId, entity];
}

// ── AI Insight events ─────────────────────────────────────────────────────────

/// Fetches the recent symptom logs to display on the log-selection page.
class FetchSymptomLogsForInsight extends HomeEvent {
  final String userId;

  const FetchSymptomLogsForInsight({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Sends selected logs to the AI and stores the generated insight.
class GenerateAiInsight extends HomeEvent {
  final String userId;
  final List<SymptomLogSummaryEntity> selectedLogs;

  const GenerateAiInsight({required this.userId, required this.selectedLogs});

  @override
  List<Object?> get props => [userId, selectedLogs];
}

/// Saves the generated insight to the timeline / Firestore.
class SaveInsightToTimeline extends HomeEvent {
  final String userId;
  final AiInsightEntity insight;

  const SaveInsightToTimeline({required this.userId, required this.insight});

  @override
  List<Object?> get props => [userId, insight];
}

class ResetAiInsightState extends HomeEvent {
  const ResetAiInsightState();

  @override
  List<Object?> get props => [];
}
