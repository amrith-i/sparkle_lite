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

// ── Symptom states ────────────────────────────────────────────────────────────

class SymptomSubmitLoading extends HomeState {}

class SymptomSubmitSuccess extends HomeState {}

class SymptomSubmitFailure extends HomeState {
  final String message;

  const SymptomSubmitFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Upload record states ──────────────────────────────────────────────────────

class UploadRecordLoading extends HomeState {}

class UploadRecordSuccess extends HomeState {}

class UploadRecordFailure extends HomeState {
  final String message;

  const UploadRecordFailure(this.message);

  @override
  List<Object?> get props => [message];
}
