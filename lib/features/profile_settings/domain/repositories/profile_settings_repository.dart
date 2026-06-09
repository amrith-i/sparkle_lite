import '../../../../core_import.dart';

abstract class ProfileSettingsRepository {
  Future<ApiResult<ProfileSettingsEntity>> fetchProfile(String userId);

  Future<ApiResult<void>> updatePrivacySettings({
    required String userId,
    required PrivacySettingsEntity settings,
  });

  Future<ApiResult<void>> addFamilyMember({
    required String userId,
    required FamilyMemberEntity member,
  });

  Future<ApiResult<void>> removeFamilyMember({
    required String userId,
    required String memberId,
  });

  Future<ApiResult<void>> signOut();

  Future<ApiResult<ProfileSettingsEntity>> updateFamilyMember({
    required String userId,
    required FamilyMemberEntity member,
  });
}
