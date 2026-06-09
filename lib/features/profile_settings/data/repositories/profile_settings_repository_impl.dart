import '../../../../core_import.dart';

@LazySingleton(as: ProfileSettingsRepository)
class ProfileSettingsRepositoryImpl extends BaseRepository
    implements ProfileSettingsRepository {
  final ProfileSettingsRemoteDataSource remoteDataSource;

  ProfileSettingsRepositoryImpl(super.dio, {required this.remoteDataSource});

  @override
  Future<ApiResult<ProfileSettingsEntity>> fetchProfile(String userId) {
    return safeApiCall(() async {
      return remoteDataSource.fetchProfile(userId);
    });
  }

  @override
  Future<ApiResult<void>> updatePrivacySettings({
    required String userId,
    required PrivacySettingsEntity settings,
  }) {
    return safeApiCall(() async {
      final dto = PrivacySettingsDto.fromEntity(settings);
      await remoteDataSource.updatePrivacySettings(userId: userId, dto: dto);
    });
  }

  @override
  Future<ApiResult<void>> addFamilyMember({
    required String userId,
    required FamilyMemberEntity member,
  }) {
    return safeApiCall(() async {
      final dto = FamilyMemberDto.fromEntity(member);
      await remoteDataSource.addFamilyMember(userId: userId, dto: dto);
    });
  }

  @override
  Future<ApiResult<void>> removeFamilyMember({
    required String userId,
    required String memberId,
  }) {
    return safeApiCall(() async {
      await remoteDataSource.removeFamilyMember(
        userId: userId,
        memberId: memberId,
      );
    });
  }

  @override
  Future<ApiResult<void>> signOut() {
    return safeApiCall(() async {
      await remoteDataSource.signOut();
    });
  }

  @override
  Future<ApiResult<ProfileSettingsEntity>> updateFamilyMember({
    required String userId,
    required FamilyMemberEntity member,
  }) {
    return safeApiCall(() async {
      final dto = FamilyMemberDto.fromEntity(member);
      await remoteDataSource.updateFamilyMember(userId: userId, dto: dto);
      return await remoteDataSource.fetchProfile(userId);
    });
  }
}
