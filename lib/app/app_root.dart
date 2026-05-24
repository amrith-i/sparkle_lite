import 'package:sparkle_lite/core_import.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        ScreenScaler.instance.init(
          Size(constraints.maxWidth, constraints.maxHeight),
        );

        return BlocProvider.value(
          value: getIt<SessionBloc>(),
          child: const MyApp(),
        );
      },
    );
  }
}
