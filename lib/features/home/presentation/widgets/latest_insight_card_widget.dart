import '../../../../core_import.dart';

class LatestInsightCardWidget extends StatelessWidget {
  final InsightEntity insight;
  final VoidCallback onTap;

  const LatestInsightCardWidget({
    super.key,
    required this.insight,
    required this.onTap,
  });

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
                  fontSize: context.sp(mobile: 16),
                  color: HomeColors.insightIcon,
                ),
              ),
              SizedBox(width: context.w(mobile: 8)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Health Insight · ',
                      style: HomeTextStyles.insightTitle(context),
                    ),
                    SizedBox(height: context.h(mobile: 4)),
                    Text(
                      insight.body,
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
