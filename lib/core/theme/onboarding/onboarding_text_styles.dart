import '../../../core_import.dart';

class OnboardingTextStyles {
  OnboardingTextStyles._();

  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 26),
    fontWeight: FontWeight.w800,
    color: OnboardingColors.titleText,
    fontFamily: 'Inter',
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w400,
    color: OnboardingColors.subtitleText,
    fontFamily: 'Inter',
    height: 1.6,
  );

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w700,
    color: OnboardingColors.buttonText,
    fontFamily: 'Inter',
    letterSpacing: 0.3,
  );

  static TextStyle skip(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w500,
    color: OnboardingColors.skipText,
    fontFamily: 'Inter',
  );
}
