import '../../../../core_import.dart';

@RoutePage()
class SignUpPage extends StatefulWidget implements AutoRouteWrapper {
  const SignUpPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AuthBloc>(), child: this);
  }

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final AuthBloc _bloc;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AuthBloc>();
    _nameController.addListener(
      () => _bloc.add(SignUpNameChanged(_nameController.text)),
    );
    _emailController.addListener(
      () => _bloc.add(SignUpEmailChanged(_emailController.text)),
    );
    _passwordController.addListener(
      () => _bloc.add(SignUpPasswordChanged(_passwordController.text)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.router.replace(const SessionGateRoute());
        } else if (state is AuthError) {
          AppNotifier.show(context, state.message, type: MessageType.error);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final formState = state is SignUpFormState
              ? state
              : const SignUpFormState();
          final isLoading = state is AuthLoading;
          final isDesktop = context.isDesktop;

          return isDesktop
              ? _SignUpDesktop(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formState: formState,
                  isLoading: isLoading,
                  bloc: _bloc,
                )
              : _SignUpMobile(
                  nameController: _nameController,
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

// ─── Mobile layout — 100% unchanged from original ────────────────────────────

class _SignUpMobile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SignUpFormState formState;
  final bool isLoading;
  final AuthBloc bloc;

  const _SignUpMobile({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.formState,
    required this.isLoading,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AuthPaddings.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(mobile: 16)),
              const _BackButton(),
              SizedBox(height: context.h(mobile: 24)),
              Text(
                'Create your account',
                style: AuthTextStyles.heading(context),
              ),
              SizedBox(height: context.h(mobile: 28)),
              _SignUpForm(
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                nameError: formState.nameError,
                emailError: formState.emailError,
                passwordError: formState.passwordError,
                onFieldSubmitted: () => bloc.add(const SignUpFormValidated()),
              ),
              SizedBox(height: context.h(mobile: 8)),
              AuthGradientButton(
                label: 'Create Account',
                isLoading: isLoading,
                onPressed: () => bloc.add(const SignUpFormValidated()),
              ),
              SizedBox(height: context.h(mobile: 20)),
              AuthNoteCard(
                text:
                    'Sensitive fields are always optional. You are in control.',
                emoji: '✦',
                decoration: AuthDecorations.sensitiveNoteCard(),
              ),
              SizedBox(height: context.h(mobile: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Desktop layout — proper two-column, constrained form ────────────────────

class _SignUpDesktop extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SignUpFormState formState;
  final bool isLoading;
  final AuthBloc bloc;

  const _SignUpDesktop({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.formState,
    required this.isLoading,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.background,
      body: Row(
        children: [
          // Left — gradient brand panel (55%)
          const Expanded(flex: 55, child: AuthDesktopBrandPanel()),

          // Right — white form panel (45%)
          Expanded(
            flex: 45,
            child: AuthDesktopFormShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Back button
                  AuthWebBackButton(onTap: () => context.router.maybePop()),
                  const SizedBox(height: 28),

                  // App wordmark
                  Row(
                    children: const [
                      AuthWebLogo(size: 36),
                      SizedBox(width: 10),
                      Text(
                        'Sparkle Lite',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AuthColors.titleText,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Heading
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AuthColors.titleText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Start your private health journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: AuthColors.subtitleText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Name field
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AuthColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AuthWebFormField(
                    controller: nameController,
                    hint: 'Your name or nickname',
                    textInputAction: TextInputAction.next,
                    borderColor: formState.nameError != null
                        ? AppColors.error
                        : AuthColors.fieldBorder,
                  ),
                  if (formState.nameError != null)
                    AuthWebErrorText(message: formState.nameError!),
                  const SizedBox(height: 14),

                  // Email field
                  const Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AuthColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AuthWebFormField(
                    controller: emailController,
                    hint: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    borderColor: formState.emailError != null
                        ? AppColors.error
                        : AuthColors.fieldBorder,
                  ),
                  if (formState.emailError != null)
                    AuthWebErrorText(message: formState.emailError!),
                  const SizedBox(height: 14),

                  // Password field
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AuthColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AuthWebFormField(
                    controller: passwordController,
                    hint: 'Password (min 6 chars)',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    borderColor: formState.passwordError != null
                        ? AppColors.error
                        : AuthColors.fieldBorder,
                    onFieldSubmitted: (_) =>
                        bloc.add(const SignUpFormValidated()),
                  ),
                  if (formState.passwordError != null)
                    AuthWebErrorText(message: formState.passwordError!),
                  const SizedBox(height: 24),

                  // Create account button — constrained, not full screen
                  AuthWebGradientButton(
                    label: 'Create Account',
                    isLoading: isLoading,
                    onPressed: () => bloc.add(const SignUpFormValidated()),
                  ),
                  const SizedBox(height: 24),

                  // Sign in link
                  Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.router.maybePop(),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13),
                            children: [
                              const TextSpan(
                                text: 'Already have an account?  ',
                                style: TextStyle(
                                  color: AuthColors.subtitleText,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                  color: AuthColors.buttonGradientEnd,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Sensitive note
                  AuthWebNoteCard(
                    text:
                        'Sensitive fields are always optional. You are in control.',
                    emoji: '✦',
                    decoration: AuthDecorations.sensitiveNoteCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared mobile sub-widgets (unchanged from original) ─────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.maybePop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AuthIcons.arrowBack,
            size: context.w(mobile: 16),
            color: AuthColors.subtitleText,
          ),
          const SizedBox(width: 4),
          Text('Back', style: AuthTextStyles.backButton(context)),
        ],
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onFieldSubmitted;

  const _SignUpForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.nameError,
    this.emailError,
    this.passwordError,
    required this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFormField(
          controller: nameController,
          hint: 'Your name or nickname',
          textInputAction: TextInputAction.next,
          borderColor: nameError != null
              ? AppColors.error
              : AuthColors.fieldBorder,
        ),
        if (nameError != null) ...[
          const SizedBox(height: 4),
          AuthErrorText(message: nameError!),
        ],
        SizedBox(height: context.h(mobile: 14)),
        AppFormField(
          controller: emailController,
          hint: 'Email address',
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
          hint: 'Password (min 6 chars)',
          obscureText: true,
          textInputAction: TextInputAction.done,
          borderColor: passwordError != null
              ? AppColors.error
              : AuthColors.fieldBorder,
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
