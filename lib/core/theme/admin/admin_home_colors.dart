// lib/core/admin_home/admin_home_colors.dart

import 'package:daily_finance_manager/core_import.dart';

class AdminHomeColors {
  AdminHomeColors._();

  static const Color primaryBlue = AppColors.primaryBlue;
  static const Color primaryBlueLight = AppColors.primaryBlueLight;
  static const Color redAccent = AppColors.primaryRed;
  static const Color redLight = AppColors.primaryRedLight;
  static const Color greenSuccess = AppColors.successAccent;
  static const Color background = AppColors.backgroundSecondary;
  static const Color cardBackground = AppColors.backgroundSecondary;
  static const Color white = AppColors.white;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textLight = AppColors.neutral;
  static const Color border = AppColors.border;
  static const Color borderLight = AppColors.border;
  static const Color trackBackground = AppColors.border;
  static const Color dashedLine = AppColors.divider;
  static const Color expiredBackground = AppColors.errorBg;
  static const Color activeBackground = AppColors.successBg;

  static const LinearGradient blueGradient = AppColors.primaryBlueGradient;
  static const LinearGradient activeArcGradient = AppColors.primaryBlueGradient;
  static const LinearGradient redArcGradient = LinearGradient(
    colors: [AppColors.primaryRedLight, AppColors.primaryRed],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient adminHomePrimaryBlueGradientHeaderBottom =
      AppColors.adminHomePrimaryBlueGradient;
}
