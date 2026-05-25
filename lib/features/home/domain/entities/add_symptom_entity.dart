import '../../../../core_import.dart';

class AddSymptomEntity extends Equatable {
  final DateTime date;
  final String periodStatus;
  final String flowLevel;
  final int painLevel;
  final String mood;
  final List<String> symptoms;
  final String? notes;

  const AddSymptomEntity({
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
    date,
    periodStatus,
    flowLevel,
    painLevel,
    mood,
    symptoms,
    notes,
  ];
}
