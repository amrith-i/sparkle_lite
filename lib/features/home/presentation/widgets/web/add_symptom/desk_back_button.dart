import '../../../../../../core_import.dart';

class DeskBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const DeskBackButton({super.key, required this.onTap});

  @override
  State<DeskBackButton> createState() => DeskBackButtonState();
}

class DeskBackButtonState extends State<DeskBackButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFF3F0F8) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE8E0F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 13,
                color: _hovered
                    ? const Color(0xFF6B4FA8)
                    : const Color(0xFF9B8FB0),
              ),
              const SizedBox(width: 6),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _hovered
                      ? const Color(0xFF6B4FA8)
                      : const Color(0xFF9B8FB0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
