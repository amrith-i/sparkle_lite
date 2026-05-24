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
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      nameError: formState.nameError,
                      emailError: formState.emailError,
                      passwordError: formState.passwordError,
                      onFieldSubmitted: () =>
                          _bloc.add(const SignUpFormValidated()),
                    ),
                    SizedBox(height: context.h(mobile: 8)),
                    AuthGradientButton(
                      label: 'Create Account',
                      isLoading: isLoading,
                      onPressed: () => _bloc.add(const SignUpFormValidated()),
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
        },
      ),
    );
  }
}

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
