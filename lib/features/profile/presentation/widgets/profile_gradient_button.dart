import '../../../../core_import.dart';

class ProfileGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const ProfileGradientButton({
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
        padding: ProfilePaddings.buttonPadding,
        decoration: ProfileDecorations.gradientButton(),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: ProfileColors.buttonText,
                ),
              )
            : Text(label, style: ProfileTextStyles.gradientButton(context)),
      ),
    );
  }
}
