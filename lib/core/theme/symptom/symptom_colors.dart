import '../../../core_import.dart';

class SymptomColors {
  SymptomColors._();

  // Backgrounds
  static const Color background = AppColors.backgroundSecondary;
  static const Color white = AppColors.white;
  static const Color cardBg = AppColors.white;

  // Text
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color neutral = AppColors.neutral;

  // Border
  static const Color border = AppColors.border;

  // Filter chip selected
  static const Color chipSelectedBg = Color(0xFFFDE8ED);
  static const Color chipSelectedBorder = Color(0xFFE8355A);
  static const Color chipSelectedText = Color(0xFFE8355A);

  // Period status tag colors
  static const Color periodOngoingBg = Color(0xFFFFEDED);
  static const Color periodOngoingText = Color(0xFFE8355A);
  static const Color periodStartedBg = Color(0xFFFFEDED);
  static const Color periodStartedText = Color(0xFFE8355A);
  static const Color periodEndedBg = Color(0xFFEDE8FF);
  static const Color periodEndedText = Color(0xFF7B52C1);
  static const Color noPeriodBg = Color(0xFFF0F0F0);
  static const Color noPeriodText = Color(0xFF6B7280);

  // Flow tag
  static const Color flowLightBg = Color(0xFFFFEDED);
  static const Color flowLightText = Color(0xFFE8355A);
  static const Color flowMediumBg = Color(0xFFFFDDDD);
  static const Color flowMediumText = Color(0xFFD03050);
  static const Color flowHeavyBg = Color(0xFFFFCCCC);
  static const Color flowHeavyText = Color(0xFFB02040);
  static const Color flowNoneBg = Color(0xFFF0F0F0);
  static const Color flowNoneText = Color(0xFF6B7280);

  // Symptom tag
  static const Color symptomTagBg = Color(0xFFF0F0F0);
  static const Color symptomTagText = AppColors.textSecondary;

  // Pain level bar colors
  static const Color painLow = Color(0xFF4CAF50); // 0–3 green
  static const Color painMid = Color(0xFFFFA726); // 4–6 orange
  static const Color painHigh = Color(0xFFE8355A); // 7–10 red
  static const Color painTrack = AppColors.border;

  // Buttons
  static const Color primaryRed = Color(0xFFE8355A);
  static const Color deleteBtnBorder = Color(0xFFE8355A);
  static const Color deleteBtnText = Color(0xFFE8355A);
  static const Color editBtnBorder = AppColors.border;
  static const Color editBtnText = AppColors.textPrimary;

  // Log Now button gradient
  static const List<Color> logNowGradient = [
    Color(0xFFE8355A),
    Color(0xFF7B52C1),
  ];

  // Empty state
  static const Color emptyIconBg = Color(0xFFFDE8ED);

  // Progress bar track
  static const Color progressTrack = AppColors.border;
}
