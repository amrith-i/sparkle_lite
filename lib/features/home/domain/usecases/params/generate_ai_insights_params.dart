import '../../../../../core_import.dart';

class GenerateAiInsightParams extends Equatable {
  final String userId;
  final List<SymptomLogSummaryEntity> selectedLogs;

  const GenerateAiInsightParams({
    required this.userId,
    required this.selectedLogs,
  });

  @override
  List<Object?> get props => [userId, selectedLogs];
}
