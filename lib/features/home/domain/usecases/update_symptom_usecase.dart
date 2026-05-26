import '../../../../core_import.dart';

@injectable
class UpdateSymptomUsecase {
  final HomeRepository repository;

  UpdateSymptomUsecase(this.repository);

  Future<ApiResult<void>> call(UpdateSymptomParams params) {
    return repository.updateSymptom(
      userId: params.userId,
      logId: params.logId,
      entity: params.entity,
    );
  }
}
