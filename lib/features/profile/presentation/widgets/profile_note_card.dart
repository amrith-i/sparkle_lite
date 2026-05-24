import '../../../../core_import.dart';

class ProfileNoteCard extends StatelessWidget {
  final String text;

  const ProfileNoteCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: ProfilePaddings.noteCard,
      decoration: ProfileDecorations.noteCard(),
      child: Text('🔒  $text', style: ProfileTextStyles.noteCard(context)),
    );
  }
}
