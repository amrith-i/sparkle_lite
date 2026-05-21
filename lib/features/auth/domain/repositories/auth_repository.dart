import '../../../../core_import.dart';

abstract class UserRepository {
  Future<UserEntity?> checkUserExists(String userId);
}
