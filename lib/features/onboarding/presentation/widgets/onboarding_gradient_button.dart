import '../../../../../core_import.dart';

class OnboardingGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const OnboardingGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: OnboardingPaddings.buttonPadding,
        decoration: OnboardingDecorations.gradientButton(),
        alignment: Alignment.center,
        child: Text(label, style: OnboardingTextStyles.button(context)),
      ),
    );
  }
}
