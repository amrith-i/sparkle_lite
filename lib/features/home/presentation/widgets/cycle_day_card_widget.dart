import '../../../../../core_import.dart';

class CycleDayCardWidget extends StatelessWidget {
  final UserProfileEntity profile;

  const CycleDayCardWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HomePaddings.sectionPadding(context),
      child: Container(
        padding: HomePaddings.cardPadding(context),
        decoration: HomeDecorations.cycleDayCard(context),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.lifeStage}',
                  style: HomeTextStyles.cycleDayNumber(context),
                ),
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
                    "12/11/2022",
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
        ),
      ),
    );
  }
}
