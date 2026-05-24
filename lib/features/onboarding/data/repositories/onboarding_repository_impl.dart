import '../../../../../core_import.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<ApiResult<void>> completeOnboarding() async {
    await localDataSource.markComplete();
    return ApiResult.success(null);
  }

  @override
  Future<ApiResult<bool>> isOnboardingComplete() async {
    final result = await localDataSource.isComplete();
    return ApiResult.success(result);
  }
}
