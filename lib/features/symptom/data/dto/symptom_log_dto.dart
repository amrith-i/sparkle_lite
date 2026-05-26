import '../../../../core_import.dart';

/// Matches exactly the fields saved by AddSymptomDto.toFirestore():
/// date, periodStatus, flowLevel, painLevel, mood, symptoms, notes, createdAt
class SymptomLogDto {
  final String id;
  final DateTime date;
  final String periodStatus;
  final String flowLevel;
  final int painLevel;
  final String mood;
  final List<String> symptoms;
  final String? notes;

  const SymptomLogDto({
    required this.id,
    required this.date,
    required this.periodStatus,
    required this.flowLevel,
    required this.painLevel,
    required this.mood,
    required this.symptoms,
    this.notes,
  });

  factory SymptomLogDto.fromFirestore(Map<String, dynamic> data, String id) {
    return SymptomLogDto(
      id: id,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      periodStatus: data['periodStatus'] as String? ?? 'No period',
      flowLevel: data['flowLevel'] as String? ?? 'None',
      painLevel: data['painLevel'] as int? ?? 0,
      mood: data['mood'] as String? ?? 'Calm',
      symptoms: List<String>.from(data['symptoms'] as List? ?? []),
      notes: data['notes'] as String?,
    );
  }

  SymptomLogEntity toEntity() => SymptomLogEntity(
        id: id,
        date: date,
        periodStatus: periodStatus,
        flowLevel: flowLevel,
        painLevel: painLevel,
        mood: mood,
        symptoms: symptoms,
        notes: notes,
      );
}
