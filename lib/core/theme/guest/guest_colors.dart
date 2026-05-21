import 'package:flutter/material.dart';

abstract final class GuestColors {
  // Scaffold
  static const Color bg = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color btnColor = Colors.blue;

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textMuted = Color(0xFF888780);

  // Status — locked (purple)
  static const Color lockedBg = Color(0xFFEEEDFE);
  static const Color lockedText = Color(0xFF3C3489);

  // Status — unlocked (green)
  static const Color unlockedBg = Color(0xFFEAF3DE);
  static const Color unlockedText = Color(0xFF27500A);

  // Status — redeemed (red)
  static const Color redeemedPillBg = Color(0xFFFFE4E4);
  static const Color redeemedText = Color(0xFFA32D2D);
  static const Color redeemedBoxBg = Color(0xFFFFF8F8);
  static const Color redeemedBoxBorder = Color(0xFFE24B4A);
  static const Color redeemedIcon = Color(0xFFE24B4A);
  static const Color redeemedSub = Color(0xFFC06060);

  // Gold scratch card
  static const Color goldStart = Color(0xFFD4A843);
  static const Color goldMid1 = Color(0xFFE8C96A);
  static const Color goldMid2 = Color(0xFFC9A030);
  static const Color goldEnd = Color(0xFFB8902A);

  // Drawer
  static const Color drawerTextMuted = Color(0xFF8A90A8);
  static const Color drawerLogoutIcon = Color(0xFFEF4444);
  static const Color drawerLogoutText = Color(0xFFDC2626);
  static const Color drawerActiveText = Color(0xFF27500A);
}
