import '../../../../../core_import.dart';

class LoginMobile extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginFormState formState;
  final bool isLoading;
  final AuthBloc bloc;

  const LoginMobile({
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AuthPaddings.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: context.h(mobile: 48)),
              const LoginHeader(),
              SizedBox(height: context.h(mobile: 40)),
              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
                obscurePassword: formState.obscurePassword,
                emailError: formState.emailError,
                passwordError: formState.passwordError,
                onTogglePassword: () =>
                    bloc.add(const LoginPasswordVisibilityToggled()),
                onFieldSubmitted: () => bloc.add(const LoginFormValidated()),
              ),
              SizedBox(height: context.h(mobile: 8)),
              AuthGradientButton(
                label: 'Sign In',
                isLoading: isLoading,
                onPressed: () => bloc.add(const LoginFormValidated()),
              ),
              SizedBox(height: context.h(mobile: 20)),
              LoginFooter(),
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
  }
}
