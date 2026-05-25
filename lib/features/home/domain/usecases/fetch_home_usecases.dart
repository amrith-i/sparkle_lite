import '../../../../core_import.dart';

@LazySingleton()
class FetchHomeUsecase implements BaseUseCase<HomeDataEntity, FetchHomeParams> {
  final HomeRepository repository;

  FetchHomeUsecase(this.repository);

  @override
  Future<ApiResult<HomeDataEntity>> call(FetchHomeParams params) {
    return repository.fetchHomeData(params.userId);
  }
}
