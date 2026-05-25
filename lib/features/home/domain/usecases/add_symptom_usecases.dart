import '../../../../core_import.dart';

@injectable
class AddSymptomUsecase {
  final HomeRepository repository;

  AddSymptomUsecase(this.repository);

  Future<ApiResult<void>> call(AddSymptomParams params) {
    return repository.addSymptom(userId: params.userId, entity: params.entity);
  }
}
