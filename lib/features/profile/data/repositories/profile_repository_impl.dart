import '../../../../../core_import.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<void>> saveProfile(UserProfileEntity profile) async {
    await remoteDataSource.saveProfile({
      'uid': profile.uid,
      'name': profile.name,
      'ageRange': profile.ageRange,
      'lifeStage': profile.lifeStage,
      'conditions': profile.conditions,
      'medications': profile.medications,
      'updatedAt': DateTime.now().toIso8601String(),
    }, profile.uid);
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<UserProfileEntity?>> getProfile(String uid) async {
    final data = await remoteDataSource.getProfile(uid);
    if (data == null) return ApiResult.success(null);
    return ApiResult.success(
      UserProfileEntity(
        uid: data['uid'] as String,
        name: data['name'] as String,
        ageRange: data['ageRange'] as String,
        lifeStage: data['lifeStage'] as String,
        conditions: List<String>.from(data['conditions'] ?? []),
        medications: data['medications'] as String?,
      ),
    );
  }
}
