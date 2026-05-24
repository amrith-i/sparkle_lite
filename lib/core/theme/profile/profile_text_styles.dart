import '../../../core_import.dart';

class ProfileTextStyles {
  ProfileTextStyles._();

  static TextStyle stepLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w500,
    color: ProfileColors.subtitleText,
    fontFamily: 'Inter',
  );

  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 24),
    fontWeight: FontWeight.w800,
    color: ProfileColors.titleText,
    fontFamily: 'Inter',
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle fieldLabel(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w600,
    color: ProfileColors.labelText,
    fontFamily: 'Inter',
  );

  static TextStyle optionalTag(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: ProfileColors.optionalText,
    fontFamily: 'Inter',
  );

  static TextStyle helperText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: ProfileColors.subtitleText,
    fontFamily: 'Inter',
    height: 1.5,
  );

  static TextStyle chipText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w500,
    color: ProfileColors.chipText,
    fontFamily: 'Inter',
  );

  static TextStyle chipSelectedText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w600,
    color: ProfileColors.chipSelectedText,
    fontFamily: 'Inter',
  );

  static TextStyle radioText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w500,
    color: ProfileColors.radioText,
    fontFamily: 'Inter',
  );

  static TextStyle radioSelectedText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w700,
    color: ProfileColors.radioSelectedText,
    fontFamily: 'Inter',
  );

  static TextStyle noteCard(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: ProfileColors.noteCardText,
    fontFamily: 'Inter',
    height: 1.5,
  );

  static TextStyle backButton(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w600,
    color: ProfileColors.backButtonText,
    fontFamily: 'Inter',
  );

  static TextStyle gradientButton(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w700,
    color: ProfileColors.buttonText,
    fontFamily: 'Inter',
    letterSpacing: 0.3,
  );
}
