import '../../../../core_import.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(
          create: (_) => getIt<ProfileCheckBloc>()..add(CheckProfile()),
        ),
      ],
      child: this,
    );
  }

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final AuthBloc _bloc;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AuthBloc>();
    _emailController.addListener(
      () => _bloc.add(LoginEmailChanged(_emailController.text)),
    );
    _passwordController.addListener(
      () => _bloc.add(LoginPasswordChanged(_passwordController.text)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveSession() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    final storage = getIt<UserSessionStorage>();
    final existing = storage.read();
    await storage.save(
      UserSessionModel(
        uid: firebaseUser.uid,
        userId: existing?.userId ?? 0,
        outletId: existing?.outletId,
        outletName: existing?.outletName,
        name: existing?.name ?? firebaseUser.displayName,
        outletAddress: existing?.outletAddress,
        role: existing?.role ?? UserRole.user,
        roleName: existing?.roleName ?? 'User',
        phone: existing?.phone ?? firebaseUser.phoneNumber ?? '',
        driverId: existing?.driverId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCheckBloc, ProfileCheckState>(
          listener: (context, state) {
            if (state is ProfileExists) {
              context.router.replaceAll([const HomeRoute()]);
            } else if (state is ProfileNotFound) {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                context.router.replaceAll([const OnboardingRoute()]);
              }
            }
          },
        ),

        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthAuthenticated) {
              await _saveSession();
              if (!mounted) return;
              context.read<ProfileCheckBloc>().add(CheckProfile());
            } else if (state is AuthError) {
              AppNotifier.show(context, state.message, type: MessageType.error);
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final formState = state is LoginFormState
              ? state
              : const LoginFormState();
          final isLoading = state is AuthLoading;
          final isDesktop = context.isDesktop;

          return isDesktop
              ? LoginDesktop(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formState: formState,
                  isLoading: isLoading,
                  bloc: _bloc,
                )
              : LoginMobile(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formState: formState,
                  isLoading: isLoading,
                  bloc: _bloc,
                );
        },
      ),
    );
  }
}
