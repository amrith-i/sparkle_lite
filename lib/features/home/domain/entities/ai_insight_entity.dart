import '../../../../core_import.dart';

class AiInsightEntity extends Equatable {
  final String id;
  final String summary;
  final String patternNoticed;
  final List<String> suggestedQuestions;
  final String whenToSeekCare;
  final DateTime generatedDate;
  final List<String> logIds;

  const AiInsightEntity({
    required this.id,
    required this.summary,
    required this.patternNoticed,
    required this.suggestedQuestions,
    required this.whenToSeekCare,
    required this.generatedDate,
    required this.logIds,
  });

  @override
  List<Object?> get props => [
    id,
    summary,
    patternNoticed,
    suggestedQuestions,
    whenToSeekCare,
    generatedDate,
    logIds,
  ];
}
