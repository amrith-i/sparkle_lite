import '../../../../core_import.dart';

/// Lightweight representation of a symptom log shown on the log-selection page.
class SymptomLogSummaryEntity extends Equatable {
  final String id;
  final DateTime date;
  final String periodStatus;
  final int painLevel;
  final String mood;

  const SymptomLogSummaryEntity({
    required this.id,
    required this.date,
    required this.periodStatus,
    required this.painLevel,
    required this.mood,
  });

  @override
  List<Object?> get props => [id, date, periodStatus, painLevel, mood];
}
