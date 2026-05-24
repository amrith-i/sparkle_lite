import '../../../../../core_import.dart';

@LazySingleton()
class CompleteOnboardingUsecase {
  final OnboardingRepository repository;

  CompleteOnboardingUsecase(this.repository);

  Future<ApiResult<void>> call() => repository.completeOnboarding();
}
