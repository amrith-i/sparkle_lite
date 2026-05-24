import '../../../core_import.dart';

class HomeTextStyles {
  HomeTextStyles._();

  static TextStyle greeting(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: HomeColors.greetingText,
    fontFamily: 'Inter',
  );

  static TextStyle name(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 24),
    fontWeight: FontWeight.w800,
    color: HomeColors.nameText,
    fontFamily: 'Inter',
    height: 1.2,
  );

  static TextStyle badge(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w500,
    color: HomeColors.badgeText,
    fontFamily: 'Inter',
  );

  static TextStyle avatarLetter(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.w700,
    color: HomeColors.avatarText,
    fontFamily: 'Inter',
  );

  static TextStyle cycleDayNumber(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 28),
    fontWeight: FontWeight.w800,
    color: HomeColors.cycleDayNumber,
    fontFamily: 'Inter',
  );

  static TextStyle cycleDayLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
    color: HomeColors.cycleDayLabel,
    fontFamily: 'Inter',
    letterSpacing: 0.5,
  );

  static TextStyle nextPeriodLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: HomeColors.nextPeriodLabel,
    fontFamily: 'Inter',
  );

  static TextStyle nextPeriodDate(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w700,
    color: HomeColors.nextPeriodDate,
    fontFamily: 'Inter',
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w700,
    color: HomeColors.sectionTitle,
    fontFamily: 'Inter',
    letterSpacing: 1.2,
  );

  static TextStyle quickActionLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
    color: HomeColors.quickActionLabel,
    fontFamily: 'Inter',
    height: 1.3,
  );

  static TextStyle logDate(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w700,
    color: HomeColors.logDate,
    fontFamily: 'Inter',
  );

  static TextStyle tag(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w500,
    color: HomeColors.tagText,
    fontFamily: 'Inter',
  );

  static TextStyle progressLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w500,
    color: HomeColors.progressLabel,
    fontFamily: 'Inter',
  );

  static TextStyle recordTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w700,
    color: HomeColors.recordTitle,
    fontFamily: 'Inter',
  );

  static TextStyle recordSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w400,
    color: HomeColors.recordSubtitle,
    fontFamily: 'Inter',
  );

  static TextStyle recordTag(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
    color: HomeColors.recordTagText,
    fontFamily: 'Inter',
  );

  static TextStyle navLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 10),
    fontWeight: FontWeight.w600,
    fontFamily: 'Inter',
  );
}
