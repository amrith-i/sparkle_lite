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
        // ProfileCheckBloc — fires at page open, redirects if profile exists
        BlocListener<ProfileCheckBloc, ProfileCheckState>(
          listener: (context, state) {
            if (state is ProfileExists) {
              context.router.replaceAll([const HomeRoute()]);
            }
            // ProfileNotFound → stay on login, nothing to do
          },
        ),
        // AuthBloc — fires after user submits login form
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthAuthenticated) {
              await _saveSession();
              if (!mounted) return;
              // Re-check profile now that user is logged in
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

          return Scaffold(
            backgroundColor: AuthColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: AuthPaddings.page,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.h(mobile: 48)),
                    const _LoginHeader(),
                    SizedBox(height: context.h(mobile: 40)),
                    _LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: formState.obscurePassword,
                      emailError: formState.emailError,
                      passwordError: formState.passwordError,
                      onTogglePassword: () =>
                          _bloc.add(const LoginPasswordVisibilityToggled()),
                      onFieldSubmitted: () =>
                          _bloc.add(const LoginFormValidated()),
                    ),
                    SizedBox(height: context.h(mobile: 8)),
                    AuthGradientButton(
                      label: 'Sign In',
                      isLoading: isLoading,
                      onPressed: () => _bloc.add(const LoginFormValidated()),
                    ),
                    SizedBox(height: context.h(mobile: 20)),
                    _LoginFooter(),
                    SizedBox(height: context.h(mobile: 20)),
                    AuthNoteCard(
                      text:
                          'Your data is private and never shared without your consent.',
                      emoji: '🔒',
                      decoration: AuthDecorations.privacyNoteCard(),
                    ),
                    SizedBox(height: context.h(mobile: 24)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── ProfileCheckBloc ─────────────────────────────────────────────────────────

// event
abstract class ProfileCheckEvent extends Equatable {
  const ProfileCheckEvent();
  @override
  List<Object?> get props => [];
}

class CheckProfile extends ProfileCheckEvent {}

// state
abstract class ProfileCheckState extends Equatable {
  const ProfileCheckState();
  @override
  List<Object?> get props => [];
}

class ProfileCheckInitial extends ProfileCheckState {}

class ProfileChecking extends ProfileCheckState {}

class ProfileExists extends ProfileCheckState {}

class ProfileNotFound extends ProfileCheckState {}

// bloc
@injectable
class ProfileCheckBloc extends Bloc<ProfileCheckEvent, ProfileCheckState> {
  final ProfileRemoteDataSource profileDataSource;

  ProfileCheckBloc(this.profileDataSource) : super(ProfileCheckInitial()) {
    on<CheckProfile>(_onCheckProfile);
  }

  Future<void> _onCheckProfile(
    CheckProfile event,
    Emitter<ProfileCheckState> emit,
  ) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // No Firebase user yet (page opened before login) — stay on login
    if (uid == null) {
      emit(ProfileNotFound());
      return;
    }

    emit(ProfileChecking());

    try {
      final data = await profileDataSource.getProfile(uid);
      if (data != null && data.isNotEmpty) {
        emit(ProfileExists());
      } else {
        emit(ProfileNotFound());
      }
    } catch (_) {
      emit(ProfileNotFound());
    }
  }
}

// ─── Page widgets ─────────────────────────────────────────────────────────────

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(AuthIcons.spark, size: context.w(mobile: 28)),
        SizedBox(height: context.h(mobile: 16)),
        Text('Welcome back', style: AuthTextStyles.heading(context)),
        SizedBox(height: context.h(mobile: 6)),
        Text(
          'Sign in to your health space',
          style: AuthTextStyles.subtitle(context),
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onTogglePassword;
  final VoidCallback onFieldSubmitted;

  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    this.emailError,
    this.passwordError,
    required this.onTogglePassword,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFormField(
          controller: emailController,
          hint: 'priya@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          borderColor: emailError != null
              ? AppColors.error
              : AuthColors.fieldBorder,
        ),
        if (emailError != null) ...[
          const SizedBox(height: 4),
          AuthErrorText(message: emailError!),
        ],
        SizedBox(height: context.h(mobile: 14)),
        AppFormField(
          controller: passwordController,
          hint: '••••••••',
          obscureText: obscurePassword,
          textInputAction: TextInputAction.done,
          borderColor: passwordError != null
              ? AppColors.error
              : AuthColors.fieldBorder,
          suffixIcon: Icon(
            obscurePassword ? AuthIcons.visibilityOff : AuthIcons.visibility,
            size: context.w(mobile: 20),
            color: AuthColors.subtitleText,
          ),
          onSuffixPressed: onTogglePassword,
          onFieldSubmitted: (_) => onFieldSubmitted(),
        ),
        if (passwordError != null) ...[
          const SizedBox(height: 4),
          AuthErrorText(message: passwordError!),
        ],
        SizedBox(height: context.h(mobile: 20)),
      ],
    );
  }
}

class _LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('New here? ', style: AuthTextStyles.footerNormal(context)),
        GestureDetector(
          onTap: () => context.router.push(const SignUpRoute()),
          child: Text(
            'Create account',
            style: AuthTextStyles.footerLink(context),
          ),
        ),
      ],
    );
  }
}
