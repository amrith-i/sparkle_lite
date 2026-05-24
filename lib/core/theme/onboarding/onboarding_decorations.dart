import '../../../core_import.dart';

class OnboardingDecorations {
  OnboardingDecorations._();

  static BoxDecoration iconContainer(BuildContext context) => BoxDecoration(
    color: OnboardingColors.iconBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 24)),
  );

  static BoxDecoration gradientButton() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        OnboardingColors.buttonGradientStart,
        OnboardingColors.buttonGradientEnd,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );
}
