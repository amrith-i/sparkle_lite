import '../../../../core_import.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeDataEntity data;

  const HomeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class SymptomSubmitLoading extends HomeState {}

class SymptomSubmitSuccess extends HomeState {}

class SymptomSubmitFailure extends HomeState {
  final String message;

  const SymptomSubmitFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UploadRecordLoading extends HomeState {}

class UploadRecordSuccess extends HomeState {}

class UploadRecordFailure extends HomeState {
  final String message;

  const UploadRecordFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DoctorVisitSubmitLoading extends HomeState {}

class DoctorVisitSubmitSuccess extends HomeState {}

class DoctorVisitSubmitFailure extends HomeState {
  final String message;

  const DoctorVisitSubmitFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class SymptomLogsLoading extends HomeState {}

class SymptomLogsLoaded extends HomeState {
  final List<SymptomLogSummaryEntity> logs;

  const SymptomLogsLoaded(this.logs);

  @override
  List<Object?> get props => [logs];
}

class SymptomLogsFailure extends HomeState {
  final String message;

  const SymptomLogsFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AiInsightGenerating extends HomeState {}

class AiInsightGenerated extends HomeState {
  final AiInsightEntity insight;

  const AiInsightGenerated(this.insight);

  @override
  List<Object?> get props => [insight];
}

class AiInsightGenerateFailure extends HomeState {
  final String message;

  const AiInsightGenerateFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InsightSavingToTimeline extends HomeState {}

class InsightSavedToTimeline extends HomeState {}

class InsightSaveToTimelineFailure extends HomeState {
  final String message;

  const InsightSaveToTimelineFailure(this.message);

  @override
  List<Object?> get props => [message];
}
