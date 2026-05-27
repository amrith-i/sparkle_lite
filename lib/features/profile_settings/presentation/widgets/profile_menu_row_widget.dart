import '../../../../core_import.dart';

class ProfileMenuRowWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuRowWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ProfileSettingsDecorations.card(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: ProfileSettingsTextStyles.menuTitle),
            ),
            const Icon(
              Icons.chevron_right,
              color: ProfileSettingsColors.menuArrow,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
