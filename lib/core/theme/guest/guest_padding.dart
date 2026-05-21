import '../../../core_import.dart';

abstract final class GuestPadding {
  static EdgeInsets header(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 20),
    vertical: context.h(mobile: 20),
  );

  static EdgeInsets screenH(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 24));

  static EdgeInsets statusPill(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 20),
    vertical: context.h(mobile: 6),
  );

  static EdgeInsets sectionSubtitle(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 40));

  static EdgeInsets drawerHeader(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 24),
    vertical: context.h(mobile: 32),
  );

  static EdgeInsets drawerItem(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 20),
    vertical: context.h(mobile: 10),
  );
}
