import '../../../../core_import.dart';

class ProfileRadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ProfileRadioOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: ProfileDecorations.radioOption(selected: selected),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: selected
                  ? ProfileTextStyles.radioSelectedText(context)
                  : ProfileTextStyles.radioText(context),
            ),
            if (selected)
              Icon(
                Icons.check,
                size: context.sp(mobile: 18),
                color: ProfileColors.radioSelected,
              ),
          ],
        ),
      ),
    );
  }
}
