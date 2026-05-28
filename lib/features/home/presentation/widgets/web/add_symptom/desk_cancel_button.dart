import '../../../../../../core_import.dart';

class DeskCancelButton extends StatefulWidget {
  final VoidCallback onTap;
  const DeskCancelButton({super.key, required this.onTap});

  @override
  State<DeskCancelButton> createState() => DeskCancelButtonState();
}

class DeskCancelButtonState extends State<DeskCancelButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF3F0F8) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E0F0)),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _hovered
                  ? const Color(0xFF6B4FA8)
                  : const Color(0xFF7B6B8A),
            ),
          ),
        ),
      ),
    );
  }
}
