import '../../../core_import.dart';

class HomeTextStyles {
  HomeTextStyles._();

  static TextStyle greeting(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    color: HomeColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle userName(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 26),
    fontWeight: FontWeight.bold,
    color: HomeColors.textPrimary,
  );

  static TextStyle sectionLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w700,
    color: HomeColors.textSecondary,
    letterSpacing: 1.0,
  );

  static TextStyle cycleDayNumber(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 30),
    fontWeight: FontWeight.bold,
    color: HomeColors.cycleDay,
  );

  static TextStyle cycleDayLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 10),
    fontWeight: FontWeight.w600,
    color: HomeColors.textSecondary,
    letterSpacing: 0.8,
  );

  static TextStyle nextPeriodLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: HomeColors.textSecondary,
  );

  static TextStyle nextPeriodDate(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w700,
    color: HomeColors.textPrimary,
  );

  static TextStyle quickActionLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
    color: HomeColors.textPrimary,
  );

  static TextStyle recentLogDate(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w700,
    color: HomeColors.textPrimary,
  );

  static TextStyle tagText(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 11), fontWeight: FontWeight.w500);

  static TextStyle painScore(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w600,
    color: HomeColors.textSecondary,
  );

  static TextStyle recordTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w700,
    color: HomeColors.textPrimary,
  );

  static TextStyle recordSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: HomeColors.textSecondary,
  );

  static TextStyle badgeText(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 11), fontWeight: FontWeight.w600);

  static TextStyle insightTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w700,
    color: HomeColors.insightText,
  );

  static TextStyle insightBody(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: HomeColors.insightText,
  );

  static TextStyle reminderTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w700,
    color: HomeColors.reminderText,
  );

  static TextStyle reminderSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: HomeColors.reminderText,
  );

  static TextStyle bottomNavLabel(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 10), fontWeight: FontWeight.w500);

  static TextStyle periodTrackingBadge(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
    color: HomeColors.periodTrackingBadgeText,
  );
}
