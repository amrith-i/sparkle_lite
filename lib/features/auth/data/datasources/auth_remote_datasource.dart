import '../../../../../core_import.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserDto> login({required String email, required String password});
  Future<AuthUserDto> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Stream<AuthUserDto?> get authStateChanges;
}
