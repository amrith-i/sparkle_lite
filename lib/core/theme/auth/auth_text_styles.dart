import 'package:daily_finance_manager/core_import.dart';
import 'package:flutter/material.dart';
import 'auth_colors.dart';

class AuthTextStyles {
  AuthTextStyles._();

  static TextStyle appTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 36),
    fontWeight: FontWeight.w800,
    color: AuthColors.white,
    letterSpacing: 0.5,
    height: 1.1,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    color: AuthColors.white.withOpacity(0.85),
    fontWeight: FontWeight.w400,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 22),
    fontWeight: FontWeight.w600,
    color: AuthColors.textPrimary,
  );

  static TextStyle inputText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    color: AuthColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static TextStyle inputHint(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    color: AuthColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static TextStyle rememberMeText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    color: AuthColors.textSecondary,
  );

  static TextStyle button(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 17),
    fontWeight: FontWeight.w600,
    color: AuthColors.white,
  );

  // Add to AuthTextStyles
  static TextStyle welcomeTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 30),
    fontWeight: FontWeight.w700,
    color: AuthColors.white,
  );

  static TextStyle userIdText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    color: AuthColors.white.withOpacity(0.85),
    fontWeight: FontWeight.w500,
  );

  static TextStyle pinAsterisk(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 28),
    fontWeight: FontWeight.w700,
    color: AuthColors.primaryBlue,
  );
}
