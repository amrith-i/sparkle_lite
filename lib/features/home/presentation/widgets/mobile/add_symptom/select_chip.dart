import '../../../../../../core_import.dart';

class SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;

  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
    this.selectedTextColor,
    this.selectedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final selBg = selectedColor ?? const Color(0xFFFDE8ED);
    final selText = selectedTextColor ?? HomeColors.primaryRed;
    final selBorder = selectedBorderColor ?? HomeColors.primaryRed;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(mobile: 16),
          vertical: context.h(mobile: 8),
        ),
        decoration: BoxDecoration(
          color: selected ? selBg : HomeColors.white,
          borderRadius: BorderRadius.circular(context.r(mobile: 20)),
          border: Border.all(
            color: selected ? selBorder : HomeColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.sp(mobile: 13),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? selText : HomeColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
