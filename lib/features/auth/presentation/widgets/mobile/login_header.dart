import '../../../../../core_import.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

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
