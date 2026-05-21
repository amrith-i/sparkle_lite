import 'package:daily_finance_manager/config/config.dart';
import 'package:daily_finance_manager/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'auth_colors.dart';

class AuthDecorations {
  AuthDecorations._();

  static const BoxDecoration primaryGradient = BoxDecoration(
    gradient: AuthColors.primaryBlueGradient,
  );

  static const BoxDecoration whiteTopRounded = BoxDecoration(
    color: AuthColors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
  );

  static const BoxDecoration iconBackground = BoxDecoration(
    color: Color(0xFFDCEAFF),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const RoundedRectangleBorder checkboxShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  static const BorderSide checkboxBorder = BorderSide(
    color: AuthColors.border,
    width: 1.5,
  );

  static BoxDecoration inputPrefixIcon(BuildContext context) => BoxDecoration(
    color: AuthColors.inputPrefixIcon,
    borderRadius: BorderRadius.circular(context.r(mobile: 8)),
  );

  static ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AuthColors.primaryBlue,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );
}
