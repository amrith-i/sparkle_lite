import '../../../../../core_import.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    // Replace with your AutoRoute navigation logic
    // e.g. context.router.replace(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AuthDecorations.splashBackground(),
        child: const _SplashContent(),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

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
          const _SplashDots(),
        ],
      ),
    );
  }
}

class _SplashDots extends StatelessWidget {
  const _SplashDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == 0 ? 10 : 8,
          height: i == 0 ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == 0
                ? AuthColors.buttonGradientEnd
                : AuthColors.fieldBorder.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}
