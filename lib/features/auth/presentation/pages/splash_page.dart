import '../../../../../core_import.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    _navigate();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    // e.g. context.router.replace(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return Scaffold(
      body: Container(
        decoration: AuthDecorations.splashBackground(),
        child: FadeTransition(
          opacity: _fadeIn,
          child: isDesktop ? const _SplashDesktop() : const _SplashMobile(),
        ),
      ),
    );
  }
}

// ─── Mobile splash (unchanged) ────────────────────────────────────────────────

class _SplashMobile extends StatelessWidget {
  const _SplashMobile();

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

// ─── Desktop splash — centred, with subtle card + larger type ─────────────────

class _SplashDesktop extends StatelessWidget {
  const _SplashDesktop();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo — fixed size, not mobile-scaled
          Container(
            width: 96,
            height: 96,
            decoration: AuthDecorations.logoContainer(context),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: AuthColors.buttonText,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Sparkle Lite',
            style: TextStyle(
              color: AuthColors.buttonText,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your private health companion',
            style: TextStyle(
              color: AuthColors.buttonText.withOpacity(0.8),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          const _SplashDots(),
        ],
      ),
    );
  }
}

// ─── Dots — shared between mobile and desktop ─────────────────────────────────

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
