import '../../../../core_import.dart';

@RoutePage()
class SessionGatePage extends StatefulWidget {
  const SessionGatePage({super.key});

  @override
  State<SessionGatePage> createState() => _SessionGatePageState();
}

class _SessionGatePageState extends State<SessionGatePage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Small delay to let the splash animate if needed
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // FirebaseAuth is the source of truth.
    // If the user is still signed in, Firebase Auth persists the token.
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      // Sync uid into local storage in case it was never saved
      // (handles upgrade from old app version without uid field).
      final storage = getIt<UserSessionStorage>();
      if (storage.uid == null) {
        final existing = storage.read();
        if (existing != null) {
          await storage.save(
            UserSessionModel(
              uid: firebaseUser.uid,
              userId: existing.userId,
              outletId: existing.outletId,
              outletName: existing.outletName,
              name: existing.name,
              outletAddress: existing.outletAddress,
              role: existing.role,
              roleName: existing.roleName,
              phone: existing.phone,
              driverId: existing.driverId,
            ),
          );
        } else {
          // No prior session at all — save a minimal one
          await storage.save(
            UserSessionModel(
              uid: firebaseUser.uid,
              userId: 0,
              role: UserRole.user,
              roleName: 'User',
              phone: firebaseUser.phoneNumber ?? '',
            ),
          );
        }
      }

      if (!mounted) return;
      context.router.replaceAll([const HomeRoute()]);
    } else {
      if (!mounted) return;
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash while checking session
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
