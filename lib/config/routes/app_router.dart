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

    AutoRoute(
      page: MainShellRoute.page,
      path: '/app',
      children: [
        AutoRoute(page: HomeRoute.page, path: '', initial: true),
        AutoRoute(page: SymptomRoute.page, path: 'symptoms'),
        AutoRoute(page: RecordsRoute.page, path: 'records'),
        AutoRoute(page: TimelineRoute.page, path: 'timeline'),
      ],
    ),

    AutoRoute(
      page: DoctorVisitSummaryRoute.page,
      path: '/doctor-summary-visit',
    ),
    AutoRoute(page: AiInsightRoute.page, path: '/ai-insights'),
    AutoRoute(
      page: AiInsightProcessingRoute.page,
      path: '/ai-insights-processing',
    ),
    AutoRoute(page: AiInsightResultRoute.page, path: '/ai-insights-result'),
    AutoRoute(page: AddSymptomRoute.page, path: '/add-symptoms'),
    AutoRoute(page: UploadRecordRoute.page, path: '/upload-records'),
  ];
}
