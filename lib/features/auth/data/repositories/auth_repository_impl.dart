import '../../../../../core_import.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(super.dio, {required this.remoteDataSource});

  @override
  Future<ApiResult<AuthUserEntity>> login({
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final dto = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return dto.toEntity();
    });
  }

  @override
  Future<ApiResult<AuthUserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return safeApiCall(() async {
      final dto = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return dto.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> logout() {
    return safeApiCall(() => remoteDataSource.logout());
  }

  @override
  Stream<AuthUserEntity?> get authStateChanges =>
      remoteDataSource.authStateChanges.map((dto) => dto?.toEntity());
}
