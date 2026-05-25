import '../../../../core_import.dart';

enum HomeNavTab { home, symptoms, records, timeline, profile }

class HomeBottomNavWidget extends StatelessWidget {
  final HomeNavTab currentTab;
  final ValueChanged<HomeNavTab> onTabChanged;

  const HomeBottomNavWidget({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HomeColors.white,
        border: Border(
          top: BorderSide(color: HomeColors.bottomNavBorder, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.h(mobile: 8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: HomeNavTab.values.map((tab) {
              return _NavItem(
                tab: tab,
                isActive: tab == currentTab,
                onTap: () => onTabChanged(tab),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final HomeNavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  String get _emoji {
    switch (tab) {
      case HomeNavTab.home:
        return '🏠';
      case HomeNavTab.symptoms:
        return '🌸';
      case HomeNavTab.records:
        return '📁';
      case HomeNavTab.timeline:
        return '📅';
      case HomeNavTab.profile:
        return '👤';
    }
  }

  String get _label {
    switch (tab) {
      case HomeNavTab.home:
        return 'HOME';
      case HomeNavTab.symptoms:
        return 'SYMPTOMS';
      case HomeNavTab.records:
        return 'RECORDS';
      case HomeNavTab.timeline:
        return 'TIMELINE';
      case HomeNavTab.profile:
        return 'PROFILE';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? HomeColors.bottomNavActive
        : HomeColors.bottomNavInactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_emoji, style: TextStyle(fontSize: context.sp(mobile: 20))),
          SizedBox(height: context.h(mobile: 2)),
          Text(
            _label,
            style: HomeTextStyles.bottomNavLabel(context).copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: context.h(mobile: 3)),
              width: context.w(mobile: 4),
              height: context.h(mobile: 4),
              decoration: const BoxDecoration(
                color: HomeColors.bottomNavActive,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
