import '../../../../../core_import.dart';

class LoginDesktop extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginFormState formState;
  final bool isLoading;
  final AuthBloc bloc;

  const LoginDesktop({
    super.key,
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
          const Expanded(flex: 55, child: AuthDesktopBrandPanel()),

          Expanded(
            flex: 45,
            child: AuthDesktopFormShell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: 36),

                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AuthColors.titleText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to your health space',
                    style: TextStyle(
                      fontSize: 14,
                      color: AuthColors.subtitleText,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AuthColors.titleText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  AuthWebFormField(
                    controller: emailController,
                    hint: 'priya@example.com',
                    keyboardType: TextInputType.emailAddress,
                    borderColor: formState.emailError != null
                        ? AppColors.error
                        : AuthColors.fieldBorder,
                  ),
                  if (formState.emailError != null)
                    AuthWebErrorText(message: formState.emailError!),
                  const SizedBox(height: 18),

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
                    hint: '••••••••',
                    obscureText: formState.obscurePassword,
                    textInputAction: TextInputAction.done,
                    borderColor: formState.passwordError != null
                        ? AppColors.error
                        : AuthColors.fieldBorder,
                    suffixIcon: Icon(
                      formState.obscurePassword
                          ? AuthIcons.visibilityOff
                          : AuthIcons.visibility,
                      size: 18,
                      color: AuthColors.subtitleText,
                    ),
                    onSuffixPressed: () =>
                        bloc.add(const LoginPasswordVisibilityToggled()),
                    onFieldSubmitted: (_) =>
                        bloc.add(const LoginFormValidated()),
                  ),
                  if (formState.passwordError != null)
                    AuthWebErrorText(message: formState.passwordError!),
                  const SizedBox(height: 24),

                  // Sign in button
                  AuthWebGradientButton(
                    label: 'Sign In',
                    isLoading: isLoading,
                    onPressed: () => bloc.add(const LoginFormValidated()),
                  ),
                  const SizedBox(height: 24),

                  // Sign up link
                  Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.router.push(const SignUpRoute()),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 13),
                            children: [
                              const TextSpan(
                                text: 'New here?  ',
                                style: TextStyle(
                                  color: AuthColors.subtitleText,
                                ),
                              ),
                              TextSpan(
                                text: 'Create account',
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

                  // Privacy note
                  AuthWebNoteCard(
                    text:
                        'Your data is private and never shared without your consent.',
                    emoji: '🔒',
                    decoration: AuthDecorations.privacyNoteCard(),
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
