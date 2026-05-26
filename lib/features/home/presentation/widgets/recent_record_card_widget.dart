import '../../../../core_import.dart';

class RecentRecordCardWidget extends StatelessWidget {
  final HealthRecordEntity record;
  final VoidCallback onTap;

  const RecentRecordCardWidget({
    super.key,
    required this.record,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.h(mobile: 2)),
                    Text(
                      '${_formatDate(record.date)}${record.doctorName != null && record.doctorName!.isNotEmpty ? ' · ${record.doctorName}' : ''}',
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
