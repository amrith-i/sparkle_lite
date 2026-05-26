import '../../../../core_import.dart';

@injectable
class FetchSymptomLogsUsecase {
  final SymptomRepository repository;

  FetchSymptomLogsUsecase(this.repository);

  Future<ApiResult<List<SymptomLogEntity>>> call(
      FetchSymptomLogsParams params) {
    return repository.fetchSymptomLogs(params.userId);
  }
}
