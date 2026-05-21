import 'package:daily_finance_manager/core_import.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: UserIdRoute.page, path: '/user-id-screen', initial: true),
    AutoRoute(page: GuestRoute.page),

    AutoRoute(page: HostRoute.page),
  ];
}
