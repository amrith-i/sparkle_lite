import '../../../../core_import.dart';

class PrivacyToggleRowWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrivacyToggleRowWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ProfileSettingsDecorations.card(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ProfileSettingsTextStyles.toggleTitle),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: ProfileSettingsTextStyles.toggleSubtitle),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: ProfileSettingsColors.toggleActive,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: ProfileSettingsColors.toggleInactive,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
