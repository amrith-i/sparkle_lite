import '../../../../core_import.dart';

@injectable
class DeleteSymptomLogUsecase {
  final SymptomRepository repository;

  DeleteSymptomLogUsecase(this.repository);

  Future<ApiResult<void>> call(DeleteSymptomLogParams params) {
    return repository.deleteSymptomLog(
      userId: params.userId,
      logId: params.logId,
    );
  }
}
