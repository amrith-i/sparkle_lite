import '../../../../../core_import.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.maybePop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AuthIcons.arrowBack,
            size: context.w(mobile: 16),
            color: AuthColors.subtitleText,
          ),
          const SizedBox(width: 4),
          Text('Back', style: AuthTextStyles.backButton(context)),
        ],
      ),
    );
  }
}
