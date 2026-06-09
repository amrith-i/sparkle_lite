import '../../../../core_import.dart';

abstract class ProfileSettingsRemoteDataSource {
  Future<ProfileSettingsEntity> fetchProfile(String userId);
  Future<void> updatePrivacySettings({
    required String userId,
    required PrivacySettingsDto dto,
  });
  Future<void> addFamilyMember({
    required String userId,
    required FamilyMemberDto dto,
  });
  Future<void> removeFamilyMember({
    required String userId,
    required String memberId,
  });
  Future<void> signOut();

  Future<void> updateFamilyMember({
    required String userId,
    required FamilyMemberDto dto,
  });
}
