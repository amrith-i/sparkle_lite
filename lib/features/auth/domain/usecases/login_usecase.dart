import '../../../../../core_import.dart';

@LazySingleton()
class LoginUsecase implements BaseUseCase<AuthUserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  Future<ApiResult<AuthUserEntity>> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}
