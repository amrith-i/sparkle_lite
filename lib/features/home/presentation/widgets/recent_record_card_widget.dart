import '../../../../core_import.dart';

class RecentRecordCardWidget extends StatelessWidget {
  final HealthRecordEntity record;
  final VoidCallback onTap;

  const RecentRecordCardWidget({
    super.key,
    required this.record,
    required this.onTap,
  });

  String _getRecordEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'lab report':
        return '💉';
      case 'prescription':
        return '💊';
      case 'scan report':
        return '🔬';
      case 'doctor visit note':
        return '🩺';
      case 'vaccination record':
        return '💉';
      default:
        return '📄';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: HomePaddings.cardPadding(context),
          decoration: HomeDecorations.card(context),
          child: Row(
            children: [
              Container(
                width: context.w(mobile: 42),
                height: context.w(mobile: 42),
                decoration: HomeDecorations.recordIconBg(context),
                alignment: Alignment.center,
                child: Text(
                  _getRecordEmoji(record.recordType),
                  style: TextStyle(fontSize: context.sp(mobile: 20)),
                ),
              ),
              SizedBox(width: context.w(mobile: 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: HomeTextStyles.recordTitle(context),
                    ),
                    SizedBox(height: context.h(mobile: 2)),
                    Text(
                      // '${DateFormat('MMM d, yyyy').format(record.date)}'
                      "12/12/2026"
                      '${record.doctorName != null ? ' · ${record.doctorName}' : ''}',
                      style: HomeTextStyles.recordSubtitle(context),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(mobile: 10),
                  vertical: context.h(mobile: 4),
                ),
                decoration: HomeDecorations.labReportBadge(context),
                child: Text(
                  record.recordType,
                  style: HomeTextStyles.badgeText(
                    context,
                  ).copyWith(color: HomeColors.labReportBadgeText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
