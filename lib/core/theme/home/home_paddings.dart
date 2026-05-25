import '../../../core_import.dart';

class HomePaddings {
  HomePaddings._();

  static EdgeInsets pagePadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 16));

  static EdgeInsets sectionPadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 16));

  static EdgeInsets cardPadding(BuildContext context) =>
      EdgeInsets.all(context.w(mobile: 14));

  static EdgeInsets headerPadding(BuildContext context) => EdgeInsets.fromLTRB(
    context.w(mobile: 16),
    context.h(mobile: 16),
    context.w(mobile: 16),
    context.h(mobile: 8),
  );
}
