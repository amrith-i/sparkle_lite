import '../../../../../core_import.dart';

class SignUpMobile extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SignUpFormState formState;
  final bool isLoading;
  final AuthBloc bloc;

  const SignUpMobile({
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AuthPaddings.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(mobile: 16)),
              const BackButton(),
              SizedBox(height: context.h(mobile: 24)),
              Text(
                'Create your account',
                style: AuthTextStyles.heading(context),
              ),
              SizedBox(height: context.h(mobile: 28)),
              SignUpForm(
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
