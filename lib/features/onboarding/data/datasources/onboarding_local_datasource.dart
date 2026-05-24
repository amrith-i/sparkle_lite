import '../../../../../core_import.dart';

abstract class OnboardingLocalDataSource {
  Future<void> markComplete();
  Future<bool> isComplete();
}

@LazySingleton(as: OnboardingLocalDataSource)
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences prefs;

  OnboardingLocalDataSourceImpl(this.prefs);

  static const _key = 'onboarding_complete';

  @override
  Future<void> markComplete() => prefs.setBool(_key, true);

  @override
  Future<bool> isComplete() async => prefs.getBool(_key) ?? false;
}
