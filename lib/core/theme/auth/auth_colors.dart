import '../../../core_import.dart';

class AuthColors {
  AuthColors._();

  static const Color background = AppColors.background;
  static const Color surface = AppColors.surface;

  static const Color iconSpark = AppColors.textPrimary;

  static const Color titleText = AppColors.textPrimary;
  static const Color subtitleText = AppColors.textSecondary;
  static const Color linkText = AppColors.primaryPink;

  static const Color fieldBorder = AppColors.primaryPink;
  static const Color fieldFocusBorder = AppColors.primaryBlue;
  static const Color fieldFill = AppColors.white;

  static const Color buttonGradientStart = AppColors.gradientStart;
  static const Color buttonGradientEnd = AppColors.gradientEnd;
  static const Color buttonText = AppColors.white;

  static const Color privacyBg = Color(0xFFE6F7F1);
  static const Color privacyText = AppColors.textSecondary;

  static const Color sensitiveNoteBg = AppColors.primaryLight;
  static const Color sensitiveNoteText = AppColors.primaryBlue;

  static const Color errorText = AppColors.error;

  static const List<Color> splashGradient = [
    Color(0xFFFDF2F8),
    Color(0xFFF3E8FF),
  ];

  static const List<Color> logoGradient = [
    AppColors.gradientStart,
    AppColors.gradientEnd,
  ];
}
