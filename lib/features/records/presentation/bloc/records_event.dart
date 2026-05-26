import '../../../../core_import.dart';

abstract class RecordsEvent extends Equatable {
  const RecordsEvent();

  @override
  List<Object?> get props => [];
}

class LoadHealthRecords extends RecordsEvent {
  final String userId;
  const LoadHealthRecords({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FilterHealthRecords extends RecordsEvent {
  final RecordsFilterType filter;
  const FilterHealthRecords({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class DeleteHealthRecord extends RecordsEvent {
  final String userId;
  final String recordId;
  const DeleteHealthRecord({required this.userId, required this.recordId});

  @override
  List<Object?> get props => [userId, recordId];
}
