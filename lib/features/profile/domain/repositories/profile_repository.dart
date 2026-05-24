import '../../../../../core_import.dart';

abstract class ProfileRepository {
  Future<ApiResult<void>> saveProfile(UserProfileEntity profile);
  Future<ApiResult<UserProfileEntity?>> getProfile(String uid);
}
