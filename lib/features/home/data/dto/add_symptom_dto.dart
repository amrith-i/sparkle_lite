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

  /// Used when **creating** a new symptom log document.
  /// Includes createdAt so Firestore timestamps the first write.
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

  /// Used when **updating** an existing symptom log document.
  /// Does NOT touch createdAt — preserves the original timestamp.
  /// Uses FieldValue.delete() to remove the notes field when cleared.
  Map<String, dynamic> toFirestoreForUpdate() {
    return {
      'date': Timestamp.fromDate(date),
      'periodStatus': periodStatus,
      'flowLevel': flowLevel,
      'painLevel': painLevel,
      'mood': mood,
      'symptoms': symptoms,
      'notes': notes ?? FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
