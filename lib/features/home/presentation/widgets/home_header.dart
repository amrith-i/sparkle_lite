import '../../../../core_import.dart';

class HomeHeaderWidget extends StatelessWidget {
  final UserProfileEntity profile;
  final VoidCallback onAvatarTap;

  const HomeHeaderWidget({
    super.key,
    required this.profile,
    required this.onAvatarTap,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';

    final nameParts = name.trim().split(' ');

    if (nameParts.length == 1) {
      // Single name - take first letter
      return nameParts[0][0].toUpperCase();
    } else {
      // Two or more names - take first letter of first and last name
      final firstInitial = nameParts[0][0].toUpperCase();
      final lastInitial = nameParts[nameParts.length - 1][0].toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.headerPadding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getGreeting(), style: HomeTextStyles.greeting(context)),
                SizedBox(height: context.h(mobile: 2)),
                Row(
                  children: [
                    Text(profile.name, style: HomeTextStyles.userName(context)),
                    SizedBox(width: context.w(mobile: 6)),
                    const Text('✦', style: TextStyle(fontSize: 18)),
                  ],
                ),
                SizedBox(height: context.h(mobile: 6)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(mobile: 10),
                    vertical: context.h(mobile: 4),
                  ),
                  decoration: HomeDecorations.periodTrackingBadge(context),
                  child: Text(
                    profile.lifeStage,
                    style: HomeTextStyles.periodTrackingBadge(context),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: context.w(mobile: 44),
              height: context.w(mobile: 44),
              decoration: HomeDecorations.avatar(context),
              alignment: Alignment.center,
              child: Text(
                _getInitials(profile.name),
                style: TextStyle(
                  color: HomeColors.avatarText,
                  fontSize: context.sp(mobile: 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
