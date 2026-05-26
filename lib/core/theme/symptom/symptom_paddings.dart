import '../../../core_import.dart';

class SymptomPaddings {
  SymptomPaddings._();

  static EdgeInsets pagePadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 16));

  static EdgeInsets cardPadding(BuildContext context) =>
      EdgeInsets.all(context.w(mobile: 16));

  static EdgeInsets chipPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 14),
    vertical: context.h(mobile: 8),
  );
}
