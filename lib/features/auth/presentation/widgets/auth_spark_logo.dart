import '../../../../../core_import.dart';

class AuthSparkLogo extends StatelessWidget {
  final double size;

  const AuthSparkLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(mobile: size),
      height: context.w(mobile: size),
      decoration: AuthDecorations.logoContainer(context),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          color: AuthColors.buttonText,
          size: context.sp(mobile: size * 0.44),
        ),
      ),
    );
  }
}
