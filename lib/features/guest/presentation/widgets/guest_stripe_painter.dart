import '../../../../core_import.dart';

class GuestStripePainter extends CustomPainter {
  const GuestStripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GuestColors.surface.withOpacity(0.06)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width + size.height; i += 28) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
