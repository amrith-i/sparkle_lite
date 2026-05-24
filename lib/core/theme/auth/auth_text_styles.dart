import '../../../core_import.dart';

class AuthTextStyles {
  AuthTextStyles._();

  static TextStyle appName(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 28),
    fontWeight: FontWeight.w800,
    color: AuthColors.titleText,
    fontFamily: 'Inter',
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle tagline(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: AuthColors.subtitleText,
    fontFamily: 'Inter',
  );

  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 26),
    fontWeight: FontWeight.w800,
    color: AuthColors.titleText,
    fontFamily: 'Inter',
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: AuthColors.subtitleText,
    fontFamily: 'Inter',
  );

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w700,
    color: AuthColors.buttonText,
    fontFamily: 'Inter',
    letterSpacing: 0.3,
  );

  static TextStyle footerNormal(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: AuthColors.subtitleText,
    fontFamily: 'Inter',
  );

  static TextStyle footerLink(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w600,
    color: AuthColors.linkText,
    fontFamily: 'Inter',
  );

  static TextStyle privacyNote(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: AuthColors.privacyText,
    fontFamily: 'Inter',
    height: 1.5,
  );

  static TextStyle errorText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: AuthColors.errorText,
    fontFamily: 'Inter',
  );

  static TextStyle backButton(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w500,
    color: AuthColors.subtitleText,
    fontFamily: 'Inter',
  );
}
