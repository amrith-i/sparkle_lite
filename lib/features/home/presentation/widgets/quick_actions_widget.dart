
import '../../../../core_import.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onLogSymptom;
  final VoidCallback onUploadRecord;
  final VoidCallback onDoctorVisit;
  final VoidCallback onAiInsight;

  const QuickActionsWidget({
    super.key,
    required this.onLogSymptom,
    required this.onUploadRecord,
    required this.onDoctorVisit,
    required this.onAiInsight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: Row(
        children: [
          _QuickActionItem(
            emoji: '📝',
            label: 'Log\nSymptom',
            onTap: onLogSymptom,
          ),
          SizedBox(width: context.w(mobile: 10)),
          _QuickActionItem(
            emoji: '📁',
            label: 'Upload\nRecord',
            onTap: onUploadRecord,
          ),
          SizedBox(width: context.w(mobile: 10)),
          _QuickActionItem(
            emoji: '🩺',
            label: 'Doctor\nVisit',
            onTap: onDoctorVisit,
          ),
          SizedBox(width: context.w(mobile: 10)),
          _QuickActionItem(
            emoji: '✦',
            label: 'AI\nInsight',
            onTap: onAiInsight,
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.h(mobile: 12),
            horizontal: context.w(mobile: 4),
          ),
          decoration: HomeDecorations.quickActionItem(context),
          child: Column(
            children: [
              Text(emoji, style: TextStyle(fontSize: context.sp(mobile: 24))),
              SizedBox(height: context.h(mobile: 6)),
              Text(
                label,
                style: HomeTextStyles.quickActionLabel(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
