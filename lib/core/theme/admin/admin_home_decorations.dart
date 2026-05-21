import 'package:daily_finance_manager/core_import.dart';

class AdminHomeDecorations {
  AdminHomeDecorations._();

  static const BoxDecoration blueHeader = BoxDecoration(
    gradient: AdminHomeColors.blueGradient,
  );

  static const BoxDecoration adminHomePrimaryBlueGradientHeaderBottom =
      BoxDecoration(
        gradient: AdminHomeColors.adminHomePrimaryBlueGradientHeaderBottom,
      );

  static BoxDecoration gaugeCard(BuildContext context) {
    return BoxDecoration(
      color: AdminHomeColors.cardBackground,
      borderRadius: BorderRadius.circular(context.r(mobile: 20)),
    );
  }

  static BoxDecoration statCard(BuildContext context) {
    return BoxDecoration(
      color: AdminHomeColors.white,
      borderRadius: BorderRadius.circular(context.r(mobile: 16)),
      border: Border.all(color: AdminHomeColors.borderLight),
    );
  }

  static BoxDecoration userCard(BuildContext context) {
    return BoxDecoration(
      color: AdminHomeColors.white,
      borderRadius: BorderRadius.circular(context.r(mobile: 10)),
      border: Border.all(color: AdminHomeColors.border),
    );
  }

  static BoxDecoration avatarDecoration(BuildContext context) {
    return BoxDecoration(
      color: AdminHomeColors.primaryBlue,
      borderRadius: BorderRadius.circular(context.r(mobile: 10)),
    );
  }

  static BoxDecoration statusBadgeDecoration(
    BuildContext context,
    bool isExpired,
  ) {
    return BoxDecoration(
      color: isExpired
          ? AdminHomeColors.expiredBackground
          : AdminHomeColors.activeBackground,
      borderRadius: BorderRadius.circular(context.r(mobile: 20)),
    );
  }

  static BoxDecoration circleAvatarDecoration(double opacity) {
    return BoxDecoration(
      color: AdminHomeColors.white.withOpacity(opacity),
      shape: BoxShape.circle,
    );
  }

  static BoxDecoration logoutButtonDecoration(BuildContext context) {
    return BoxDecoration(
      color: AdminHomeColors.white.withOpacity(0.25),
      shape: BoxShape.circle,
    );
  }

  static BoxDecoration activeIconDecoration(BuildContext context) {
    return const BoxDecoration(
      color: AdminHomeColors.primaryBlue,
      shape: BoxShape.circle,
    );
  }

  static BoxDecoration expiredIconDecoration(BuildContext context) {
    return const BoxDecoration(
      color: AdminHomeColors.redAccent,
      shape: BoxShape.circle,
    );
  }
}
