
import '../../../core_import.dart';

class SymptomTextStyles {
  SymptomTextStyles._();

  static TextStyle pageTitle(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 24),
        fontWeight: FontWeight.w700,
        color: SymptomColors.textPrimary,
      );

  static TextStyle pageSubtitle(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: FontWeight.w400,
        color: SymptomColors.textSecondary,
      );

  static TextStyle cardDate(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 15),
        fontWeight: FontWeight.w600,
        color: SymptomColors.textPrimary,
      );

  static TextStyle moodLabel(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: FontWeight.w500,
        color: SymptomColors.textSecondary,
      );

  static TextStyle tagText(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 12),
        fontWeight: FontWeight.w500,
        color: SymptomColors.textSecondary,
      );

  static TextStyle painScore(BuildContext context, Color color) => TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle notes(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 13),
        fontStyle: FontStyle.italic,
        color: SymptomColors.textSecondary,
      );

  static TextStyle filterChipLabel(BuildContext context,
          {required bool selected}) =>
      TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        color: selected
            ? SymptomColors.chipSelectedText
            : SymptomColors.textSecondary,
      );

  static TextStyle emptyTitle(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 16),
        fontWeight: FontWeight.w600,
        color: SymptomColors.textPrimary,
      );

  static TextStyle emptySubtitle(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: FontWeight.w400,
        color: SymptomColors.textSecondary,
      );

  static TextStyle logNowBtn(BuildContext context) =>
      AppTextStyles.button(context);

  static TextStyle actionBtn(BuildContext context) => TextStyle(
        fontSize: context.sp(mobile: 13),
        fontWeight: FontWeight.w500,
        color: SymptomColors.textPrimary,
      );
}
