import '../../../../core_import.dart';

class ProfileChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ProfileChip({
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
        padding: ProfilePaddings.chipPadding,
        decoration: ProfileDecorations.chip(selected: selected),
        child: Text(
          label,
          style: selected
              ? ProfileTextStyles.chipSelectedText(context)
              : ProfileTextStyles.chipText(context),
        ),
      ),
    );
  }
}
