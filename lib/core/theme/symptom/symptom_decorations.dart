import '../../../core_import.dart';

class SymptomDecorations {
  SymptomDecorations._();

  static BoxDecoration card(BuildContext context) => BoxDecoration(
    color: SymptomColors.cardBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 14)),
    border: Border.all(color: SymptomColors.border),
  );

  static BoxDecoration filterChipSelected(BuildContext context) =>
      BoxDecoration(
        color: SymptomColors.chipSelectedBg,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
        border: Border.all(color: SymptomColors.chipSelectedBorder, width: 1.5),
      );

  static BoxDecoration filterChipUnselected(BuildContext context) =>
      BoxDecoration(
        color: SymptomColors.white,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
        border: Border.all(color: SymptomColors.border),
      );
}
