import '../../core_import.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SessionGateRoute.page, path: '/', initial: true),
    AutoRoute(page: SplashRoute.page, path: '/splash'),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SignUpRoute.page, path: '/sign-up'),
    AutoRoute(page: OnboardingRoute.page, path: '/onboarding'),
    AutoRoute(page: ProfileSetupRoute.page, path: '/profile-setup'),
    AutoRoute(page: HomeRoute.page, path: '/home'),
  ];
}
