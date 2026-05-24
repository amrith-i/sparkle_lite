import '../../../../core_import.dart';

class ProfileOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ProfileOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: ProfilePaddings.buttonPadding,
        decoration: ProfileDecorations.outlineButton(),
        alignment: Alignment.center,
        child: Text(label, style: ProfileTextStyles.backButton(context)),
      ),
    );
  }
}
