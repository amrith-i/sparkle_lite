import '../../../../../core_import.dart';

class SignUpForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onFieldSubmitted;

  const SignUpForm({
    super.key,
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
