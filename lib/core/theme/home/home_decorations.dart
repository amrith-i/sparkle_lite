import '../../../core_import.dart';

class HomeDecorations {
  HomeDecorations._();

  static BoxDecoration card(BuildContext context) => BoxDecoration(
    color: HomeColors.white,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: HomeColors.border, width: 1),
  );

  static BoxDecoration cycleDayCard(BuildContext context) => BoxDecoration(
    color: HomeColors.white,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: HomeColors.border, width: 1),
  );

  static BoxDecoration quickActionItem(BuildContext context) => BoxDecoration(
    color: HomeColors.white,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
    border: Border.all(color: HomeColors.border, width: 1),
  );

  static BoxDecoration insightCard(BuildContext context) => BoxDecoration(
    color: HomeColors.insightCardBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: HomeColors.insightCardBorder, width: 1),
  );

  static BoxDecoration reminderCard(BuildContext context) => BoxDecoration(
    color: HomeColors.reminderCardBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: HomeColors.reminderCardBorder, width: 1),
  );

  static BoxDecoration periodTrackingBadge(BuildContext context) =>
      BoxDecoration(
        color: HomeColors.periodTrackingBadgeBg,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
      );

  static BoxDecoration avatar(BuildContext context) =>
      BoxDecoration(color: HomeColors.avatarBg, shape: BoxShape.circle);

  static BoxDecoration labReportBadge(BuildContext context) => BoxDecoration(
    color: HomeColors.labReportBadgeBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 20)),
  );

  static BoxDecoration nextPeriodFlower(BuildContext context) => BoxDecoration(
    color: HomeColors.nextPeriodFlowerBg,
    shape: BoxShape.circle,
  );

  static BoxDecoration recordIconBg(BuildContext context) => BoxDecoration(
    color: HomeColors.quickActionDoctorBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 10)),
  );
}
