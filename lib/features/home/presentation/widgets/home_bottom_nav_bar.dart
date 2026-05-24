import '../../../../../core_import.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(emoji: '🏠', label: 'HOME'),
    _NavItem(emoji: '🌸', label: 'SYMPTOMS'),
    _NavItem(emoji: '📁', label: 'RECORDS'),
    _NavItem(emoji: '📅', label: 'TIMELINE'),
    _NavItem(emoji: '👤', label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: HomeDecorations.navBar(),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: context.h(mobile: 10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavBarItem(
                item: _items[i],
                isActive: i == activeIndex,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String emoji;
  final String label;
  const _NavItem({required this.emoji, required this.label});
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.emoji, style: TextStyle(fontSize: context.sp(mobile: 22))),
          SizedBox(height: context.h(mobile: 3)),
          Text(
            item.label,
            style: HomeTextStyles.navLabel(context).copyWith(
              color: isActive ? HomeColors.navActive : HomeColors.navInactive,
            ),
          ),
          SizedBox(height: context.h(mobile: 2)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? context.w(mobile: 4) : 0,
            height: context.h(mobile: 4),
            decoration: BoxDecoration(
              color: HomeColors.navActive,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
