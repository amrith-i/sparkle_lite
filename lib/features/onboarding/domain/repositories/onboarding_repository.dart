import '../../../../../core_import.dart';

abstract class OnboardingRepository {
  Future<ApiResult<void>> completeOnboarding();
  Future<ApiResult<bool>> isOnboardingComplete();
}
