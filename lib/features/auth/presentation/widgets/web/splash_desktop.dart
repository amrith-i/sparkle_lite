import '../../../../../core_import.dart';

class SplashDesktop extends StatelessWidget {
  const SplashDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: AuthDecorations.logoContainer(context),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: AuthColors.buttonText,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Sparkle Lite',
            style: TextStyle(
              color: AuthColors.buttonText,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your private health companion',
            style: TextStyle(
              color: AuthColors.buttonText.withOpacity(0.8),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          const SplashDots(),
        ],
      ),
    );
  }
}
