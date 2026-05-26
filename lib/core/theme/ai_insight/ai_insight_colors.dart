import '../../../core_import.dart';

class AiInsightColors {
  AiInsightColors._();

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

  // Purple / Insight accent
  static const Color insightPurple = Color(0xFF7B52C1);
  static const Color insightPurpleLight = Color(0xFFEDE8FF);
  static const Color insightPurpleBorder = Color(0xFFD1C4E9);

  // Red accent
  static const Color primaryRed = Color(0xFFE8355A);

  // Gradient (Generate button & selected chip)
  static const List<Color> gradientColors = [
    Color(0xFFE8355A),
    Color(0xFF7B52C1),
  ];

  // Log selection card
  static const Color logCardSelectedBg = Color(0xFFF3F0FF);
  static const Color logCardSelectedBorder = Color(0xFF7B52C1);
  static const Color logCardUnselectedBg = AppColors.white;
  static const Color logCardUnselectedBorder = AppColors.border;

  // Disclaimer banner
  static const Color disclaimerBg = Color(0xFFF3F0FF);
  static const Color disclaimerBorder = Color(0xFFD1C4E9);
  static const Color disclaimerText = Color(0xFF7B52C1);
  static const Color disclaimerIcon = Color(0xFF7B52C1);

  // Loading screen
  static const Color loadingBg = AppColors.backgroundSecondary;
  static const Color loadingTitle = Color(0xFF7B52C1);
  static const Color loadingSubtitle = AppColors.textSecondary;
  static const Color loadingIcon = AppColors.textPrimary;

  // Result screen — section icon colors
  static const Color summaryIcon = Color(0xFF7B52C1);
  static const Color patternIcon = Color(0xFFE8355A);
  static const Color suggestedIcon = Color(0xFF4B9CD3);
  static const Color seekCareIcon = Color(0xFFFFA726);

  // Result screen — section card borders
  static const Color summaryCardBorder = AppColors.border;
  static const Color patternCardBorder = AppColors.border;
  static const Color suggestedCardBorder = AppColors.border;
  static const Color seekCareCardBorder = Color(0xFFFFE0B2);

  // Result screen — section header text colors
  static const Color summaryHeader = AppColors.textPrimary;
  static const Color patternHeader = Color(0xFFE8355A);
  static const Color suggestedHeader = Color(0xFF4B9CD3);
  static const Color seekCareHeader = Color(0xFFFFA726);

  // Important disclaimer card
  static const Color importantBg = Color(0xFFF7F8FC);
  static const Color importantBorder = AppColors.border;
  static const Color importantIcon = Color(0xFF7B52C1);
  static const Color importantBoldText = AppColors.textPrimary;
  static const Color importantBodyText = AppColors.textSecondary;

  // Save to Timeline button
  static const List<Color> saveButtonGradient = [
    Color(0xFF7B52C1),
    Color(0xFFE8355A),
  ];
}
