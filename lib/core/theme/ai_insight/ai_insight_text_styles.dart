import '../../../core_import.dart';

class AiInsightTextStyles {
  AiInsightTextStyles._();

  static TextStyle pageTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 24),
    fontWeight: FontWeight.w700,
    color: AiInsightColors.textPrimary,
  );

  static TextStyle pageSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.textSecondary,
  );

  static TextStyle sectionLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 10),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AiInsightColors.textSecondary,
  );

  // Log selection card
  static TextStyle logCardDate(
    BuildContext context, {
    required bool selected,
  }) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w600,
    color: selected
        ? AiInsightColors.insightPurple
        : AiInsightColors.textPrimary,
  );

  static TextStyle logCardMeta(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.textSecondary,
  );

  // Disclaimer
  static TextStyle disclaimerText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.disclaimerText,
  );

  // Generate button label
  static TextStyle generateBtn(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
    color: AiInsightColors.white,
  );

  // Loading screen
  static TextStyle loadingTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
    color: AiInsightColors.loadingTitle,
  );

  static TextStyle loadingSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.loadingSubtitle,
  );

  // Result screen
  static TextStyle resultSectionHeader(BuildContext context, Color color) =>
      TextStyle(
        fontSize: context.sp(mobile: 15),
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle resultBody(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.textPrimary,
    height: 1.5,
  );

  static TextStyle resultQuestion(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.textPrimary,
    height: 1.6,
  );

  static TextStyle importantBold(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w700,
    color: AiInsightColors.importantBoldText,
  );

  static TextStyle importantBody(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w400,
    color: AiInsightColors.importantBodyText,
  );

  static TextStyle saveBtn(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
    color: AiInsightColors.white,
  );
}
