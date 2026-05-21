import 'package:daily_finance_manager/core_import.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    final routeObserver = AutoRouteObserver();

    return GlobalKeyboardDismiss(
      child: MaterialApp.router(
        title: 'Qr Gift',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(
          navigatorObservers: () => [routeObserver],
        ),
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          useMaterial3: true,
        ),
        // builder: (context, child) {
        //   return EnvBanner(child: child ?? const SizedBox());
        // },
      ),
    );
  }
}
