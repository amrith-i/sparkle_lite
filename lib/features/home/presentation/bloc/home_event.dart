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

class FetchSymptomLogsForInsight extends HomeEvent {
  final String userId;

  const FetchSymptomLogsForInsight({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GenerateAiInsight extends HomeEvent {
  final String userId;
  final List<SymptomLogSummaryEntity> selectedLogs;

  const GenerateAiInsight({required this.userId, required this.selectedLogs});

  @override
  List<Object?> get props => [userId, selectedLogs];
}

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
