import '../../../../../core_import.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

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
