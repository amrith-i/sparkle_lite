import 'package:flutter/material.dart';

abstract final class HostColors {
  static const Color bg = Color(0xFFF5F6FA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE0E4EF);

  // Corner / accent
  static const Color cornerIdle = Color(0xFF4A6CF7);
  static const Color cornerGreen = Color(0xFF22C55E);
  static const Color cornerRed = Color(0xFFEF4444);

  // Text
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textMuted = Color(0xFF8A90A8);

  // Green state
  static const Color greenBg = Color(0xFFF0FDF4);
  static const Color greenBorder = Color(0xFF22C55E);
  static const Color greenText = Color(0xFF16A34A);

  // Red state
  static const Color redBg = Color(0xFFFFF1F2);
  static const Color redBorder = Color(0xFFEF4444);
  static const Color redText = Color(0xFFDC2626);

  // Idle state
  static const Color idleBg = Color(0xFFF0F3FF);
  static const Color idleBorder = Color(0xFFBBC5F7);
  static const Color idleText = Color(0xFF4A6CF7);
}
