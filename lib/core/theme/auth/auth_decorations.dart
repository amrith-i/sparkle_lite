import '../../../core_import.dart';

class AuthDecorations {
  AuthDecorations._();

  static BoxDecoration splashBackground() => const BoxDecoration(
    gradient: LinearGradient(
      colors: AuthColors.splashGradient,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static BoxDecoration logoContainer(BuildContext context) => BoxDecoration(
    gradient: const LinearGradient(
      colors: AuthColors.logoGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(context.r(mobile: 24)),
    boxShadow: [
      BoxShadow(
        color: AuthColors.buttonGradientStart.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration gradientButton() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [AuthColors.buttonGradientStart, AuthColors.buttonGradientEnd],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.all(Radius.circular(14)),
  );

  static BoxDecoration privacyNoteCard() => BoxDecoration(
    color: AuthColors.privacyBg,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration sensitiveNoteCard() => BoxDecoration(
    color: AuthColors.sensitiveNoteBg,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration pageBackground() =>
      const BoxDecoration(color: AuthColors.background);
}
