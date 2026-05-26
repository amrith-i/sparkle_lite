import '../../../../core_import.dart';

class LatestInsightCardWidget extends StatelessWidget {
  final InsightEntity insight;
  final VoidCallback onTap;

  const LatestInsightCardWidget({
    super.key,
    required this.insight,
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
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: HomePaddings.cardPadding(context),
          decoration: HomeDecorations.insightCard(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✦',
                style: TextStyle(
                  fontSize: context.sp(mobile: 18),
                  color: HomeColors.insightIcon,
                ),
              ),
              SizedBox(width: context.w(mobile: 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Health Insight · ${_formatDate(insight.generatedDate)}',
                      style: HomeTextStyles.insightTitle(context),
                    ),
                    SizedBox(height: context.h(mobile: 6)),
                    Text(
                      insight.patternNoticed, // Show patternNoticed, not body
                      style: HomeTextStyles.insightBody(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
