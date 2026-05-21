import '../../../../core_import.dart';

class HostCorner extends StatelessWidget {
  final Color color;
  const HostCorner({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.r(mobile: 30),
      height: context.r(mobile: 30),
      child: CustomPaint(painter: _CornerPainter(color)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  _CornerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}

class HostCornerOverlay extends StatelessWidget {
  final Color color;
  const HostCornerOverlay({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final offset = context.r(mobile: 20);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: offset,
          left: offset,
          child: HostCorner(color: color),
        ),
        Positioned(
          top: offset,
          right: offset,
          child: Transform.rotate(
            angle: 1.5708,
            child: HostCorner(color: color),
          ),
        ),
        Positioned(
          bottom: offset,
          left: offset,
          child: Transform.rotate(
            angle: -1.5708,
            child: HostCorner(color: color),
          ),
        ),
        Positioned(
          bottom: offset,
          right: offset,
          child: Transform.rotate(
            angle: 3.1416,
            child: HostCorner(color: color),
          ),
        ),
      ],
    );
  }
}
