import '../../../../../core_import.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final String? emailError;
  final String? passwordError;
  final VoidCallback onTogglePassword;
  final VoidCallback onFieldSubmitted;

  const LoginForm({
    super.key,
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
