import '../../../../../core_import.dart';

class AuthErrorText extends StatelessWidget {
  final String message;

  const AuthErrorText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        message,
        style: AuthTextStyles.errorText(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
