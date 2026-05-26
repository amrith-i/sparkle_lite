import '../../../../core_import.dart';



// ─── Usecase ──────────────────────────────────────────────────────────────────

@injectable
class FetchSymptomLogsForInsightUsecase {
  final HomeRepository repository;

  FetchSymptomLogsForInsightUsecase(this.repository);

  Future<ApiResult<List<SymptomLogSummaryEntity>>> call(
    FetchSymptomLogsForInsightParams params,
  ) {
    return repository.fetchSymptomLogs(userId: params.userId);
  }
}
