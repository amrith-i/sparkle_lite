import '../../../../../../core_import.dart';

class DeskSaveButton extends StatefulWidget {
  final bool isLoading;
  final bool isEditMode;
  final VoidCallback? onTap;

  const DeskSaveButton({
    super.key,
    required this.isLoading,
    required this.isEditMode,
    required this.onTap,
  });

  @override
  State<DeskSaveButton> createState() => DeskSaveButtonState();
}

class DeskSaveButtonState extends State<DeskSaveButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AuthColors.buttonGradientStart,
                AuthColors.buttonGradientEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered && !widget.isLoading
                ? [
                    BoxShadow(
                      color: AuthColors.buttonGradientEnd.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isEditMode ? 'Update Symptom' : 'Save Log',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
