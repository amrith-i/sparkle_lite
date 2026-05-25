import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primaryBlue = Color(0xFF7C3AED); // Purple (primary brand)
  static const Color primaryPink = Color(0xFFEC4899); // Pink (accent)
  static const Color primaryLight = Color(
    0xFFF3E8FF,
  ); // Light purple background

  // Secondary
  static const Color secondaryPeach = Color(0xFFFDA4AF); // Soft pink/peach
  static const Color secondaryLavender = Color(0xFFDDD6FE); // Lavender

  // Gradients
  static const Color gradientStart = Color(0xFF7C3AED); // Purple
  static const Color gradientEnd = Color(0xFFEC4899); // Pink

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF9FAFB);
  static const Color grey200 = Color(0xFFF3F4F6);
  static const Color grey300 = Color(0xFFE5E7EB);
  static const Color grey400 = Color(0xFFD1D5DB);
  static const Color grey500 = Color(0xFF9CA3AF);
  static const Color grey600 = Color(0xFF6B7280);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Background
  static const Color background = Color(0xFFFAF5FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF9FAFB);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Gradients as list
  static const List<Color> primaryGradient = [gradientStart, gradientEnd];
  static const List<Color> lightGradient = [primaryLight, secondaryLavender];

  // Common Notification
  static const successAccent = Color(0xFF2B925B);
  static const successBg = Color(0xFFF0F9F4);
  static const successBorder = Color(0x802C985A);
  static const errorAccent = Color(0xFFD3060B);
  static const errorBg = Color(0xFFFFF6F5);
  static const errorBorder = Color(0x80D3060B);
  static const warningAccent = Color(0xFFDD8B00);
  static const warningBg = Color(0xFFFFFCF5);
  static const warningBorder = Color(0x80F2A521);
  static const infoAccent = Color(0xFF4374D1);
  static const infoBg = Color(0xFFF5F8FF);
  static const infoBorder = Color(0x804374D1);

  // Transparent
  static const transparent = Colors.transparent;

  // Aliases used by feature-level color files
  static const Color primaryRed = Color(0xFFE8355A);
  static const Color primaryBlueLight = primaryLight;
  static const LinearGradient primaryBlueGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
  );

  // Semantic layout tokens
  static const Color backgroundSecondary = grey100;
  static const Color border = grey300;
  static const Color divider = grey200;
  static const Color neutral = grey500;
  static const Color progressInActive = grey300;
}
