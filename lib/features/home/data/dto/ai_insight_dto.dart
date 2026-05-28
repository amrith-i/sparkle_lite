import '../../../../core_import.dart';

class SymptomLogSummaryDto {
  final String id;
  final DateTime date;
  final String periodStatus;
  final int painLevel;
  final String mood;

  const SymptomLogSummaryDto({
    required this.id,
    required this.date,
    required this.periodStatus,
    required this.painLevel,
    required this.mood,
  });

  factory SymptomLogSummaryDto.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return SymptomLogSummaryDto(
      id: id,
      date: (data['date'] as Timestamp).toDate(),
      periodStatus: data['periodStatus'] as String? ?? '',
      painLevel: (data['painLevel'] as num?)?.toInt() ?? 0,
      mood: data['mood'] as String? ?? '',
    );
  }

  SymptomLogSummaryEntity toEntity() => SymptomLogSummaryEntity(
    id: id,
    date: date,
    periodStatus: periodStatus,
    painLevel: painLevel,
    mood: mood,
  );

  String toPromptString() {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final dateStr = '${months[date.month - 1]} ${date.day}, ${date.year}';
    return '- $dateStr | $periodStatus | Pain: $painLevel/10 | Mood: $mood';
  }
}

class AiInsightDto {
  final String id;
  final String summary;
  final String patternNoticed;
  final List<String> suggestedQuestions;
  final String whenToSeekCare;
  final DateTime generatedDate;
  final List<String> logIds;

  const AiInsightDto({
    required this.id,
    required this.summary,
    required this.patternNoticed,
    required this.suggestedQuestions,
    required this.whenToSeekCare,
    required this.generatedDate,
    required this.logIds,
  });

  factory AiInsightDto.fromAiJson(
    Map<String, dynamic> json,
    List<String> logIds,
  ) {
    return AiInsightDto(
      id: '',
      summary: json['summary'] as String? ?? '',
      patternNoticed: json['patternNoticed'] as String? ?? '',
      suggestedQuestions: List<String>.from(
        json['suggestedQuestions'] as List? ?? [],
      ),
      whenToSeekCare: json['whenToSeekCare'] as String? ?? '',
      generatedDate: DateTime.now(),
      logIds: logIds,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'summary': summary,
      'patternNoticed': patternNoticed,
      'suggestedQuestions': suggestedQuestions,
      'whenToSeekCare': whenToSeekCare,
      'generatedDate': Timestamp.fromDate(generatedDate),
      'logIds': logIds,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  AiInsightEntity toEntity() {
    return AiInsightEntity(
      id: id,
      summary: summary,
      patternNoticed: patternNoticed,
      suggestedQuestions: suggestedQuestions,
      whenToSeekCare: whenToSeekCare,
      generatedDate: generatedDate,
      logIds: logIds,
    );
  }
}
