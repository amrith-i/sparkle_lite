import '../../../../core_import.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AuthBloc>(), child: this);
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // context.router.replace(const SessionGateRoute());
          context.router.replaceAll([const OnboardingRoute()]);
        } else if (state is AuthError) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
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
