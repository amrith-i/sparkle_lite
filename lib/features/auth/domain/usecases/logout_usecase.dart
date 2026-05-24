import '../../../../../core_import.dart';

@LazySingleton()
class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<ApiResult<void>> call() => repository.logout();
}
