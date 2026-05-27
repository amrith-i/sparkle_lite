import '../../../../core_import.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SessionGatePage
//
// Routing logic:
//   • No Firebase user          → LoginRoute
//   • Firebase user + profile   → HomeRoute
//   • Firebase user, no profile → LoginRoute
//     (Login page will run ProfileCheckBloc after auth and route to Onboarding
//      if the profile is still absent.)
// ─────────────────────────────────────────────────────────────────────────────

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
    // Small delay so the splash animates before we navigate
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    // ── No authenticated user ────────────────────────────────────────────────
    if (firebaseUser == null) {
      context.router.replaceAll([const LoginRoute()]);
      return;
    }

    // ── Authenticated user — check if profile exists ─────────────────────────
    try {
      final profileDataSource = getIt<ProfileRemoteDataSource>();
      final data = await profileDataSource.getProfile(firebaseUser.uid);
      final profileExists = data != null && data.isNotEmpty;

      if (!mounted) return;

      if (profileExists) {
        // Profile found — sync uid into local storage if needed then go Home
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
        // No profile — send to Login so the full auth + onboarding flow runs
        context.router.replaceAll([const LoginRoute()]);
      }
    } catch (_) {
      // On any error default to Login
      if (!mounted) return;
      context.router.replaceAll([const LoginRoute()]);
    }
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

// ─── Splash content shown while the session check is running ─────────────────

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
