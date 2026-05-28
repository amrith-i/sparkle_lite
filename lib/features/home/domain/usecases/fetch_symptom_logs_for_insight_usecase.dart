import '../../../../core_import.dart';

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
