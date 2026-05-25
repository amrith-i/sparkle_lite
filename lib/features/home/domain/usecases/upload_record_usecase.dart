import '../../../../core_import.dart';

@injectable
class UploadRecordUsecase {
  final HomeRepository repository;

  UploadRecordUsecase(this.repository);

  Future<ApiResult<void>> call(UploadRecordParams params) {
    return repository.uploadRecord(
      userId: params.userId,
      entity: params.entity,
    );
  }
}
