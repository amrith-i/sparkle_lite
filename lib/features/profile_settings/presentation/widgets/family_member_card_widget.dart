import '../../../../core_import.dart';

class FamilyMemberCardWidget extends StatelessWidget {
  final FamilyMemberEntity member;
  final VoidCallback onRemove;

  const FamilyMemberCardWidget({
    super.key,
    required this.member,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final initial =
        member.name.isNotEmpty ? member.name[0].toUpperCase() : '?';

    return Container(
      decoration: ProfileSettingsDecorations.card(),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ProfileSettingsColors.familyAvatarBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ProfileSettingsColors.familyAvatarText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    style: ProfileSettingsTextStyles.familyName),
                const SizedBox(height: 2),
                Text(
                  '${member.relationship} · Age ${member.ageRange}',
                  style: ProfileSettingsTextStyles.familyMeta,
                ),
                if (member.healthNotes.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    member.healthNotes,
                    style: ProfileSettingsTextStyles.familyMeta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ProfileSettingsColors.removeButtonBorder,
                  width: 1,
                ),
              ),
              child: Text(
                'Remove',
                style: ProfileSettingsTextStyles.removeButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
