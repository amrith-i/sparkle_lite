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
    if (_currentTab == tab) return; // Prevent unnecessary navigation

    setState(() => _currentTab = tab);

    switch (tab) {
      case HomeNavTab.home:
        context.router.replace(const HomeRoute());
        break;

      case HomeNavTab.symptoms:
        context.router.replace(const SymptomRoute());
        break;

      case HomeNavTab.records:
        context.router.replace(const RecordsRoute());
        break;

      case HomeNavTab.timeline:
        context.router.replace(const TimelineRoute());
        break;

      case HomeNavTab.profile:
        context.router.replace(const ProfileSettingsRoute());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      body: const AutoRouter(),
      bottomNavigationBar: isDesktop
          ? null
          : HomeBottomNavWidget(
              currentTab: _currentTab,
              onTabChanged: _onTabChanged,
            ),
    );
  }
}
