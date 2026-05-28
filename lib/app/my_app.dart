import 'package:sparkle_lite/core_import.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    // final routeObserver = AutoRouteObserver();

    return GlobalKeyboardDismiss(
      child: MaterialApp.router(
        title: 'Sparkle Lite',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
        theme: ThemeData(
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          useMaterial3: true,
        ),
      ),
    );
  }
}
