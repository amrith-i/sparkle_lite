import 'package:daily_finance_manager/core_import.dart';

class AdminHomePadding {
  AdminHomePadding._();

  static EdgeInsets headerPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: context.w(mobile: 15), // Changed to 15
      vertical: context.h(mobile: 16),
    );
  }

  static EdgeInsets scrollViewBodyPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      context.w(mobile: 15), // Changed to 15
      context.h(mobile: 16),
      context.w(mobile: 15), // Changed to 15
      context.h(mobile: 100),
    );
  }

  static EdgeInsets gaugeCardPadding(BuildContext context) {
    return EdgeInsets.all(context.w(mobile: 20));
  }

  static EdgeInsets statCardPadding(BuildContext context) {
    return EdgeInsets.all(context.w(mobile: 16));
  }

  static EdgeInsets userCardTopPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      context.w(mobile: 14),
      context.h(mobile: 14),
      context.w(mobile: 14),
      context.h(mobile: 12),
    );
  }

  static EdgeInsets userCardBottomPadding(BuildContext context) {
    return EdgeInsets.fromLTRB(
      context.w(mobile: 14),
      context.h(mobile: 10),
      context.w(mobile: 14),
      context.h(mobile: 14),
    );
  }

  static EdgeInsets statusBadgePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: context.w(mobile: 12),
      vertical: context.h(mobile: 6),
    );
  }

  static EdgeInsets avatarPadding(BuildContext context) {
    return EdgeInsets.all(context.w(mobile: 26));
  }

  static EdgeInsets screenHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: context.w(mobile: 14));
  }

  static EdgeInsets bottomNavPadding(BuildContext context) {
    return EdgeInsets.zero;
  }

  static double betweenLogoAndWelcome(BuildContext context) =>
      context.h(mobile: 30);
  static double betweenWelcomeAndUserId(BuildContext context) =>
      context.h(mobile: 10);
  static double betweenTitleAndPin(BuildContext context) =>
      context.h(mobile: 30);
  static double betweenPinAndNumpad(BuildContext context) =>
      context.h(mobile: 35);
  static double betweenRowsInNumpad(BuildContext context) =>
      context.h(mobile: 8);
  static double betweenKeysInRow(BuildContext context) => context.w(mobile: 8);
  static double betweenSections(BuildContext context) => context.h(mobile: 24);
  static double betweenCards(BuildContext context) => context.h(mobile: 14);
  static double betweenStatCards(BuildContext context) => context.w(mobile: 14);
  static double betweenAvatarAndText(BuildContext context) =>
      context.w(mobile: 14);
  static double betweenStatusDotAndText(BuildContext context) =>
      context.w(mobile: 5);
  static double fabSpace(BuildContext context) => context.w(mobile: 60);
  static double bottomNavHeight(BuildContext context) => context.h(mobile: 60);
}
