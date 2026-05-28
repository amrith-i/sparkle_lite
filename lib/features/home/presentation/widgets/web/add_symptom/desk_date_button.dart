import '../../../../../../core_import.dart';

class DeskDateButton extends StatefulWidget {
  final String date;
  final VoidCallback onTap;

  const DeskDateButton({super.key, required this.date, required this.onTap});

  @override
  State<DeskDateButton> createState() => DeskDateButtonState();
}

class DeskDateButtonState extends State<DeskDateButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? HomeColors.primaryRed : const Color(0xFFE8E0F0),
              width: _hovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 16,
                color: HomeColors.primaryRed,
              ),
              const SizedBox(width: 10),
              Text(
                widget.date,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: _hovered
                    ? HomeColors.primaryRed
                    : const Color(0xFFB0A0C0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
