import '../../../core_import.dart';

class AiInsightPaddings {
  AiInsightPaddings._();

  static EdgeInsets pagePadding(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 16));

  static EdgeInsets cardPadding(BuildContext context) =>
      EdgeInsets.all(context.w(mobile: 16));

  static EdgeInsets logCardPadding(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: context.w(mobile: 16),
        vertical: context.h(mobile: 14),
      );
}
