import '../../../../../../core_import.dart';

class AuthGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        padding: AuthPaddings.buttonPadding,
        decoration: AuthDecorations.gradientButton(),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AuthColors.buttonText,
                ),
              )
            : Text(label, style: AuthTextStyles.button(context)),
      ),
    );
  }
}
