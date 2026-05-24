import '../../../../../core_import.dart';

@LazySingleton()
class SignUpUsecase implements BaseUseCase<AuthUserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  @override
  Future<ApiResult<AuthUserEntity>> call(SignUpParams params) {
    return repository.signUp(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
