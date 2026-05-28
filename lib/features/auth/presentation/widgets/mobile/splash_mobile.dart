import '../../../../../core_import.dart';

class SplashMobile extends StatelessWidget {
  const SplashMobile();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AuthSparkLogo(size: 80),
          SizedBox(height: context.h(mobile: 24)),
          Text('Sparkle Lite', style: AuthTextStyles.appName(context)),
          SizedBox(height: context.h(mobile: 8)),
          Text(
            'Your private health companion',
            style: AuthTextStyles.tagline(context),
          ),
          SizedBox(height: context.h(mobile: 32)),
          const SplashDots(),
        ],
      ),
    );
  }
}
