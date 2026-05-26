import '../../../../core_import.dart';

@injectable
class AddDoctorVisitUsecase {
  final HomeRepository repository;

  AddDoctorVisitUsecase(this.repository);

  Future<ApiResult<void>> call(AddDoctorVisitParams params) {
    return repository.addDoctorVisit(
      userId: params.userId,
      entity: params.entity,
    );
  }
}
