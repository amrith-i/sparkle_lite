import '../../../../core_import.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserEntity?> checkUserExists(String userId) async {
    return await remoteDatasource.checkUserExists(userId);
  }
}
