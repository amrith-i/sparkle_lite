import '../../../../core_import.dart';

@injectable
class DeleteHealthRecordUsecase {
  final RecordsRepository repository;

  DeleteHealthRecordUsecase(this.repository);

  Future<ApiResult<void>> call(DeleteHealthRecordParams params) {
    return repository.deleteHealthRecord(
      userId: params.userId,
      recordId: params.recordId,
    );
  }
}
