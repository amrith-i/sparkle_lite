import '../../../../../core_import.dart';

class SignUpDesktop extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SignUpFormState formState;
  final bool isLoading;
  final AuthBloc bloc;

  const SignUpDesktop({
    super.key,
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
