// lib/core/admin_home/admin_home_text_styles.dart
import 'package:daily_finance_manager/core_import.dart';

class AdminHomeTextStyles {
  AdminHomeTextStyles._();

  static TextStyle userName(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.w700,
    color: AdminHomeColors.white,
  );

  static TextStyle userRole(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    color: AdminHomeColors.white.withOpacity(0.85),
  );

  static TextStyle totalUsersCount(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 52),
    fontWeight: FontWeight.w800,
    color: AdminHomeColors.textPrimary,
    height: 1.0,
  );

  static TextStyle totalUsersLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    color: AdminHomeColors.textSecondary,
  );

  static TextStyle statCount(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 28),
    fontWeight: FontWeight.w800,
    color: AdminHomeColors.textPrimary,
  );

  static TextStyle statLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: AdminHomeColors.textSecondary,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.w700,
    color: AdminHomeColors.textPrimary,
  );

  static TextStyle viewAllText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w600,
    color: AdminHomeColors.primaryBlue,
  );

  static TextStyle userNameCard(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w600,
    color: AdminHomeColors.textPrimary,
  );

  static TextStyle userPhone(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: AdminHomeColors.textSecondary,
  );

  static TextStyle statusText(BuildContext context, bool isExpired) =>
      TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: FontWeight.w600,
        color: isExpired
            ? AdminHomeColors.redAccent
            : AdminHomeColors.greenSuccess,
      );

  static TextStyle dateLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    color: AdminHomeColors.textLight,
  );

  static TextStyle dateValue(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w700,
    color: AdminHomeColors.textPrimary,
  );

  static TextStyle expiryDateValue(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w700,
    color: AdminHomeColors.redAccent,
  );

  static TextStyle navLabel(BuildContext context, bool isSelected) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
    color: isSelected ? AdminHomeColors.primaryBlue : AdminHomeColors.textLight,
  );

  static TextStyle initialsText(BuildContext context) => TextStyle(
    color: AdminHomeColors.white,
    fontWeight: FontWeight.w700,
    fontSize: context.sp(mobile: 15),
  );
}
