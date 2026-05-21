import 'package:daily_finance_manager/core_import.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        ScreenScaler.instance.init(
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        return const MyApp();
      },
    );
  }
}
