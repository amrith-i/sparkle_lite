import '../../../core_import.dart';

class AiInsightDecorations {
  AiInsightDecorations._();

  static BoxDecoration card(BuildContext context) => BoxDecoration(
    color: AiInsightColors.cardBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: AiInsightColors.border),
  );

  static BoxDecoration logCardSelected(BuildContext context) => BoxDecoration(
    color: AiInsightColors.logCardSelectedBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(
      color: AiInsightColors.logCardSelectedBorder,
      width: 1.5,
    ),
  );

  static BoxDecoration logCardUnselected(BuildContext context) => BoxDecoration(
    color: AiInsightColors.logCardUnselectedBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: AiInsightColors.logCardUnselectedBorder),
  );

  static BoxDecoration disclaimerCard(BuildContext context) => BoxDecoration(
    color: AiInsightColors.disclaimerBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
    border: Border.all(color: AiInsightColors.disclaimerBorder),
  );

  static BoxDecoration importantCard(BuildContext context) => BoxDecoration(
    color: AiInsightColors.importantBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
    border: Border.all(color: AiInsightColors.importantBorder),
  );

  static BoxDecoration seekCareCard(BuildContext context) => BoxDecoration(
    color: AiInsightColors.cardBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: AiInsightColors.seekCareCardBorder),
  );

  static BoxDecoration generateButton(BuildContext context) => BoxDecoration(
    gradient: const LinearGradient(colors: AiInsightColors.gradientColors),
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
  );

  static BoxDecoration saveButton(BuildContext context) => BoxDecoration(
    gradient: const LinearGradient(colors: AiInsightColors.saveButtonGradient),
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
  );
}
