import '../../../../core_import.dart';

class LatestInsightCardWidget extends StatelessWidget {
  final InsightEntity insight;
  final VoidCallback onTap;
  final bool hideSensitive;

  const LatestInsightCardWidget({
    super.key,
    required this.insight,
    required this.onTap,
    required this.hideSensitive,
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
                hideSensitive ? '🔒' : '✦',
                style: TextStyle(
                  fontSize: context.sp(mobile: 18),
                  color: hideSensitive
                      ? HomeColors.insightIcon.withOpacity(0.5)
                      : HomeColors.insightIcon,
                ),
              ),
              SizedBox(width: context.w(mobile: 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hideSensitive
                          ? 'AI Health Insight · Protected'
                          : 'AI Health Insight · ${_formatDate(insight.generatedDate)}',
                      style: HomeTextStyles.insightTitle(context).copyWith(
                        color: hideSensitive
                            ? HomeColors.insightTitle.withOpacity(0.6)
                            : null,
                      ),
                    ),
                    SizedBox(height: context.h(mobile: 6)),
                    if (hideSensitive)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          context.r(mobile: 4),
                        ),
                        child: Container(
                          height: context.h(mobile: 40),
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.1),
                          child: Center(
                            child: Text(
                              '🔒 Content hidden for privacy',
                              style: TextStyle(
                                fontSize: context.sp(mobile: 12),
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        insight.patternNoticed,
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
