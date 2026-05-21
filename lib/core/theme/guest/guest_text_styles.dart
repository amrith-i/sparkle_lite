import 'package:flutter/material.dart';
import '../../../core_import.dart';
import 'guest_colors.dart';

abstract final class GuestTextStyles {
  static TextStyle appBarTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle eventName(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
    color: GuestColors.textPrimary,
  );

  static TextStyle statusPill(BuildContext context, Color color) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle sectionHeading(BuildContext context, {Color? color}) =>
      TextStyle(
        fontSize: context.sp(mobile: 17),
        fontWeight: FontWeight.bold,
        color: color ?? GuestColors.textPrimary,
      );

  static TextStyle sectionSubtitle(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 13), color: GuestColors.textMuted);

  static TextStyle shareButton(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w600,
  );

  static TextStyle scratchTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static TextStyle scratchSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: const Color(0xCCFFFFFF),
  );

  static TextStyle redeemedTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w600,
    color: GuestColors.redeemedText,
  );

  static TextStyle redeemedSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    color: GuestColors.redeemedSub,
  );

  static TextStyle drawerName(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(mobile: 20),
    fontWeight: FontWeight.w700,
  );

  static TextStyle drawerSubtitle(BuildContext context) =>
      TextStyle(color: Colors.white70, fontSize: context.sp(mobile: 13));

  static TextStyle drawerItemLabel(BuildContext context) => TextStyle(
    color: GuestColors.drawerTextMuted,
    fontSize: context.sp(mobile: 12),
  );

  static TextStyle drawerItemValue(BuildContext context, {Color? color}) =>
      TextStyle(
        color: color ?? GuestColors.textPrimary,
        fontSize: context.sp(mobile: 14),
        fontWeight: FontWeight.w600,
      );

  static TextStyle drawerLogout(BuildContext context) => TextStyle(
    color: GuestColors.drawerLogoutText,
    fontWeight: FontWeight.w600,
    fontSize: context.sp(mobile: 15),
  );
}
