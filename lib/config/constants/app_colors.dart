import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primaryBlue = Color(0xFF2582FF);
  static const Color primaryBlueLight = Color(0xFF80C6FF);
  static const Color primaryRed = Color(0xFFFF1616);
  static const Color primaryRedLight = Color(0xFFFFC0C0);
  static const Color white = Color(0xFFFFFFFF);

  static const transparent = Colors.transparent;

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color neutral = Color(0xFF757575);

  // Linear Gradient
  // static const LinearGradient primaryBlueGradient = LinearGradient(
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  //   colors: [Color(0xFF80C6FF), Color(0xFF2582FF)],
  // );
  static const LinearGradient primaryBlueGradient = LinearGradient(
    begin: Alignment(-1.0, -0.5), // Left-center, slightly up
    end: Alignment(1.0, 0.5), // Right-center, slightly down
    colors: [Color(0xFF80C6FF), Color(0xFF2582FF)],
  );

  // Background
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF7F8FC);

  // Border & Divider
  static const Color border = Color(0xFFE9EAEB);
  static const Color divider = Color(0xFFE9EAEB);

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

  // Auth
  static const inputPrefixIcon = Color(0xFFEAF2FF);
  // Add to AuthColors
  static const Color pinKeyBackground = Color(0xFFF9FAFB);
  static const Color pinKeyPressed = Color(0xFFE8F0FE);

  // Admin Home
  static const LinearGradient adminHomePrimaryBlueGradient = LinearGradient(
    begin: Alignment(-1.0, -0.5),
    end: Alignment(1.0, -0.5),
    colors: [Color(0xFF80C6FF), Color(0xFF2582FF)],
  );
}
