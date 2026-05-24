
import '../../../../core_import.dart';

@LazySingleton(as: OnboardingRemoteDatasource)
class OnboardingRemoteDatasourceImpl implements OnboardingRemoteDatasource {
  final Dio dio;

  OnboardingRemoteDatasourceImpl(this.dio);
}
