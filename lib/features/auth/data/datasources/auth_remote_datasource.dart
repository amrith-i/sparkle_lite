import '../../../../core_import.dart';

abstract class UserRemoteDatasource {
  Future<UserDto?> checkUserExists(String userId);
}
