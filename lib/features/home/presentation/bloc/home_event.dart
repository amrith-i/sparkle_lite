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
