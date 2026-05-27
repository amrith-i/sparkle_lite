import '../../../../../core_import.dart';

class CycleDayCardWidget extends StatelessWidget {
  final UserProfileEntity profile;
  final DateTime? lastPeriodStartDate;
  final int cycleLength;
  final bool hideSensitive;

  const CycleDayCardWidget({
    super.key,
    required this.profile,
    this.lastPeriodStartDate,
    this.cycleLength = 28,
    required this.hideSensitive,
  });

  String _calculateNextPeriodDate() {
    if (lastPeriodStartDate == null) return '';

    final nextPeriodDate = lastPeriodStartDate!.add(
      Duration(days: cycleLength),
    );

    // Format date
    return '${nextPeriodDate.day}/${nextPeriodDate.month}/${nextPeriodDate.year}';
  }

  int _calculateCycleDay() {
    if (lastPeriodStartDate == null) return 0;

    final now = DateTime.now();
    final difference = now.difference(lastPeriodStartDate!).inDays;

    // Calculate cycle day (1-indexed)
    int cycleDay = (difference % cycleLength) + 1;

    // Cap at cycle length
    if (cycleDay > cycleLength) cycleDay = cycleLength;

    return cycleDay;
  }

  @override
  Widget build(BuildContext context) {
    // Don't show if no period start date found
    if (lastPeriodStartDate == null) return const SizedBox.shrink();

    final cycleDay = _calculateCycleDay();
    final nextPeriodDate = _calculateNextPeriodDate();

    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: Container(
        padding: HomePaddings.cardPadding(context),
        decoration: HomeDecorations.cycleDayCard(context),
        child: hideSensitive
            ? _buildBlurredContent(context)
            : _buildNormalContent(context, cycleDay, nextPeriodDate),
      ),
    );
  }

  Widget _buildNormalContent(
    BuildContext context,
    int cycleDay,
    String nextPeriodDate,
  ) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$cycleDay', style: HomeTextStyles.cycleDayNumber(context)),
            Text('CYCLE DAY', style: HomeTextStyles.cycleDayLabel(context)),
          ],
        ),
        SizedBox(width: context.w(mobile: 16)),
        Container(
          width: 1,
          height: context.h(mobile: 40),
          color: HomeColors.border,
        ),
        SizedBox(width: context.w(mobile: 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next period expected',
                style: HomeTextStyles.nextPeriodLabel(context),
              ),
              SizedBox(height: context.h(mobile: 2)),
              Text(
                nextPeriodDate,
                style: HomeTextStyles.nextPeriodDate(context),
              ),
            ],
          ),
        ),
        Container(
          width: context.w(mobile: 36),
          height: context.w(mobile: 36),
          decoration: HomeDecorations.nextPeriodFlower(context),
          alignment: Alignment.center,
          child: const Text('🌸', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildBlurredContent(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '--',
              style: HomeTextStyles.cycleDayNumber(
                context,
              ).copyWith(color: HomeColors.cycleDay.withOpacity(0.3)),
            ),
            Text(
              'CYCLE DAY',
              style: HomeTextStyles.cycleDayLabel(
                context,
              ).copyWith(color: HomeColors.cycleDay.withOpacity(0.3)),
            ),
          ],
        ),
        SizedBox(width: context.w(mobile: 16)),
        Container(
          width: 1,
          height: context.h(mobile: 40),
          color: HomeColors.border.withOpacity(0.3),
        ),
        SizedBox(width: context.w(mobile: 16)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next period expected',
                style: HomeTextStyles.nextPeriodLabel(
                  context,
                ).copyWith(color: HomeColors.nextPeriodLabel.withOpacity(0.3)),
              ),
              SizedBox(height: context.h(mobile: 2)),
              ClipRRect(
                borderRadius: BorderRadius.circular(context.r(mobile: 4)),
                child: Container(
                  height: context.h(mobile: 20),
                  width: context.w(mobile: 100),
                  color: Colors.grey.withOpacity(0.1),
                  child: Center(
                    child: Text(
                      '🔒 Hidden',
                      style: TextStyle(
                        fontSize: context.sp(mobile: 10),
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: context.w(mobile: 36),
          height: context.w(mobile: 36),
          decoration: HomeDecorations.nextPeriodFlower(
            context,
          ).copyWith(color: HomeColors.nextPeriodFlowerBg.withOpacity(0.3)),
          alignment: Alignment.center,
          child: Opacity(
            opacity: 0.3,
            child: const Text('🌸', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
