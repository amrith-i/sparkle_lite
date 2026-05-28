import '../../../../../../core_import.dart';

class DeskSelectChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;

  const DeskSelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
    this.selectedTextColor,
    this.selectedBorderColor,
  });

  @override
  State<DeskSelectChip> createState() => DeskSelectChipState();
}

class DeskSelectChipState extends State<DeskSelectChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selBg = widget.selectedColor ?? const Color(0xFFFDE8ED);
    final selText = widget.selectedTextColor ?? HomeColors.primaryRed;
    final selBorder = widget.selectedBorderColor ?? HomeColors.primaryRed;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.selected
                ? selBg
                : _hovered
                ? const Color(0xFFFAF7FF)
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.selected
                  ? selBorder
                  : _hovered
                  ? const Color(0xFFD0C0E0)
                  : const Color(0xFFE8E0F0),
              width: widget.selected ? 1.5 : 1,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: selBorder.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
              color: widget.selected
                  ? selText
                  : _hovered
                  ? const Color(0xFF3D3050)
                  : const Color(0xFF7B6B8A),
            ),
          ),
        ),
      ),
    );
  }
}
