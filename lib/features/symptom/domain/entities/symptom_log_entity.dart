import '../../../../core_import.dart';

/// Full symptom log entity used in the symptom feature.
/// Field names match exactly what SymptomLogDto stores in Firestore.
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
