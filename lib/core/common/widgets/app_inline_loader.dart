import '../../../core_import.dart';

class AppInlineLoader extends StatefulWidget {
  final double size;
  final double speed;

  const AppInlineLoader({super.key, this.size = 22, this.speed = 2.0});

  @override
  State<AppInlineLoader> createState() => _AppInlineLoaderState();
}

class _AppInlineLoaderState extends State<AppInlineLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(mobile: widget.size),
      height: context.w(mobile: widget.size),
      child: Lottie.asset(
        AppIcons.loader,
        controller: _controller,
        fit: BoxFit.contain,
        onLoaded: (composition) {
          _controller.duration = Duration(
            microseconds: (composition.duration.inMicroseconds / widget.speed)
                .round(),
          );
          _controller
            ..forward()
            ..repeat();
        },
      ),
    );
  }
}
