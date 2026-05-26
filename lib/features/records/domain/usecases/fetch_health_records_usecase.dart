import '../../../../core_import.dart';

@injectable
class FetchHealthRecordsUsecase {
  final RecordsRepository repository;

  FetchHealthRecordsUsecase(this.repository);

  Future<ApiResult<List<HealthRecordEntity>>> call(
    FetchHealthRecordsParams params,
  ) {
    return repository.fetchHealthRecords(params.userId);
  }
}
