import 'package:daily_finance_manager/core_import.dart';
import 'package:flutter/material.dart';

class AuthColors {
  AuthColors._();

  static const Color primaryBlue = Color(0xFF2582FF);
  static const Color primaryBlueLight = Color(0xFF80C6FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFE9EAEB);
  static const Color background = Color(0xFFFFFFFF);
  static const inputPrefixIcon = AppColors.inputPrefixIcon;
  static const Color pinKeyBackground = AppColors.pinKeyBackground;
  static const Color pinKeyPressed = AppColors.pinKeyPressed;
  static const Color errorAccent = AppColors.errorAccent;

  static const LinearGradient primaryBlueGradient = LinearGradient(
    begin: Alignment(-1.0, -0.5), // Left-center, slightly up
    end: Alignment(1.0, 0.5), // Right-center, slightly down
    colors: [Color(0xFF80C6FF), Color(0xFF2582FF)],
  );
}
