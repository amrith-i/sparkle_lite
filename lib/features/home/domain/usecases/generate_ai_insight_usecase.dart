import '../../../../core_import.dart';

@injectable
class GenerateAiInsightUsecase {
  final HomeRepository repository;

  GenerateAiInsightUsecase(this.repository);

  Future<ApiResult<AiInsightEntity>> call(GenerateAiInsightParams params) {
    return repository.generateAiInsight(
      userId: params.userId,
      selectedLogs: params.selectedLogs,
    );
  }
}
