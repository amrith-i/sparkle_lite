import '../../../../core_import.dart';

@RoutePage()
class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  HomeNavTab _currentTab = HomeNavTab.home;

  void _onTabChanged(HomeNavTab tab) {
    setState(() => _currentTab = tab);

    switch (tab) {
      case HomeNavTab.home:
        context.router.replace(const HomeRoute());
        break;

      case HomeNavTab.symptoms:
        context.router.replace(const SymptomRoute());
        break;

      case HomeNavTab.records:
        // TODO: Implement Records navigation
        break;
      case HomeNavTab.timeline:
        // TODO: Implement Timeline navigation
        break;
      case HomeNavTab.profile:
        // TODO: Implement Profile navigation
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AutoRouter(),
      bottomNavigationBar: HomeBottomNavWidget(
        currentTab: _currentTab,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}
