import 'package:flutter/material.dart';
import 'profile_settings_colors.dart';

class ProfileSettingsDecorations {
  ProfileSettingsDecorations._();

  static BoxDecoration card() => BoxDecoration(
        color: ProfileSettingsColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: ProfileSettingsColors.cardBorder, width: 1),
      );

  static BoxDecoration infoBanner() => BoxDecoration(
        color: ProfileSettingsColors.infoBannerBackground,
        borderRadius: BorderRadius.circular(12),
      );

  static BoxDecoration addMemberButton() => BoxDecoration(
        color: ProfileSettingsColors.addMemberBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ProfileSettingsColors.addMemberBorder,
          width: 1.5,
          // dashed effect achieved via CustomPaint in widget
        ),
      );

  static BoxDecoration signOutButton() => BoxDecoration(
        color: ProfileSettingsColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: ProfileSettingsColors.signOutBorder, width: 1),
      );

  static InputDecoration inputDecoration({
    required String label,
    required String hint,
  }) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontSize: 13,
          color: ProfileSettingsColors.inputLabel,
        ),
        hintStyle: const TextStyle(
          fontSize: 13,
          color: ProfileSettingsColors.inputLabel,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: ProfileSettingsColors.inputBorder, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: ProfileSettingsColors.inputBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: ProfileSettingsColors.inputFocus, width: 2),
        ),
      );
}
