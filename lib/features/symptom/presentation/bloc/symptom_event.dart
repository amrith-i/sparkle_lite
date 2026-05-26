import '../../../../core_import.dart';

abstract class SymptomEvent extends Equatable {
  const SymptomEvent();

  @override
  List<Object?> get props => [];
}

class LoadSymptomLogs extends SymptomEvent {
  final String userId;
  const LoadSymptomLogs({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteSymptomLog extends SymptomEvent {
  final String userId;
  final String logId;
  const DeleteSymptomLog({required this.userId, required this.logId});

  @override
  List<Object?> get props => [userId, logId];
}

class FilterSymptomLogs extends SymptomEvent {
  final SymptomFilterType filter;
  const FilterSymptomLogs({required this.filter});

  @override
  List<Object?> get props => [filter];
}
