import '../../../../core_import.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileSettingsEntity profile;

  const ProfileHeaderWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final initial =
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U';

    return Column(
      children: [
        const SizedBox(height: 24),
        // Avatar circle
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF9B5FC0), Color(0xFF6B3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: ProfileSettingsColors.avatarText,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(profile.name, style: ProfileSettingsTextStyles.nameText),
        const SizedBox(height: 4),
        Text(profile.email, style: ProfileSettingsTextStyles.emailText),
        const SizedBox(height: 8),
        // Life stage badge
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: ProfileSettingsColors.badgeBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            profile.lifeStage,
            style: ProfileSettingsTextStyles.badgeText,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
