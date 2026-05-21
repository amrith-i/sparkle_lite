import '../../../core_import.dart';

class AppIconWidget extends StatelessWidget {
  final String asset;
  final double? size;
  final Color? color;
  final BoxFit fit;

  const AppIconWidget({
    super.key,
    required this.asset,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size ?? context.w(mobile: 26),
      height: size ?? context.w(mobile: 26),
      fit: fit,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
