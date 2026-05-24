import '../../../../../core_import.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthUserEntity>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthUserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<ApiResult<void>> logout();

  Stream<AuthUserEntity?> get authStateChanges;
}
