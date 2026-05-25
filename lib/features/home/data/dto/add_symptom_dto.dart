import '../../../../core_import.dart';

class AddSymptomDto {
  final DateTime date;
  final String periodStatus;
  final String flowLevel;
  final int painLevel;
  final String mood;
  final List<String> symptoms;
  final String? notes;

  const AddSymptomDto({
    required this.date,
    required this.periodStatus,
    required this.flowLevel,
    required this.painLevel,
    required this.mood,
    required this.symptoms,
    this.notes,
  });

  factory AddSymptomDto.fromEntity(AddSymptomEntity entity) {
    return AddSymptomDto(
      date: entity.date,
      periodStatus: entity.periodStatus,
      flowLevel: entity.flowLevel,
      painLevel: entity.painLevel,
      mood: entity.mood,
      symptoms: entity.symptoms,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'periodStatus': periodStatus,
      'flowLevel': flowLevel,
      'painLevel': painLevel,
      'mood': mood,
      'symptoms': symptoms,
      if (notes != null) 'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
