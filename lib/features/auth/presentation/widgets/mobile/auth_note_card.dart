import '../../../../../../core_import.dart';

class AuthNoteCard extends StatelessWidget {
  final String text;
  final String emoji;
  final BoxDecoration decoration;

  const AuthNoteCard({
    super.key,
    required this.text,
    required this.emoji,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AuthPaddings.noteCard,
      decoration: decoration,
      child: Text(
        '$emoji $text',
        style: AuthTextStyles.privacyNote(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
