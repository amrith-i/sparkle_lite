import 'package:flutter/material.dart';
import '../../../core_import.dart';
import 'host_colors.dart';

abstract final class HostTextStyles {
  static TextStyle appBarTitle(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(mobile: 18),
    fontWeight: FontWeight.w600,
  );

  static TextStyle heading(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w700,
    color: HostColors.textPrimary,
  );

  static TextStyle subLabel(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 13), color: HostColors.textMuted);

  static TextStyle muted(BuildContext context) =>
      TextStyle(fontSize: context.sp(mobile: 12), color: HostColors.textMuted);

  static TextStyle cardTitle(BuildContext context, Color color) => TextStyle(
    color: color,
    fontWeight: FontWeight.w700,
    fontSize: context.sp(mobile: 15),
  );

  static TextStyle cardSubtitle(BuildContext context) =>
      TextStyle(color: HostColors.textMuted, fontSize: context.sp(mobile: 12));

  static TextStyle buttonLabel(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(mobile: 16),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static TextStyle buttonLabelAlt(BuildContext context) =>
      TextStyle(color: HostColors.textMuted, fontSize: context.sp(mobile: 13));

  static TextStyle badgeLabel(BuildContext context, Color color) => TextStyle(
    color: color,
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w600,
  );

  static TextStyle dialogTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 22),
    fontWeight: FontWeight.bold,
    color: HostColors.textPrimary,
  );

  static TextStyle dialogBody(BuildContext context) =>
      TextStyle(color: HostColors.textMuted, fontSize: context.sp(mobile: 14));

  static TextStyle drawerName(BuildContext context) => TextStyle(
    color: Colors.white,
    fontSize: context.sp(mobile: 20),
    fontWeight: FontWeight.w700,
  );

  static TextStyle drawerSubtitle(BuildContext context) =>
      TextStyle(color: Colors.white70, fontSize: context.sp(mobile: 13));

  static TextStyle drawerItemLabel(BuildContext context) =>
      TextStyle(color: HostColors.textMuted, fontSize: context.sp(mobile: 12));

  static TextStyle drawerItemValue(BuildContext context, {Color? color}) =>
      TextStyle(
        color: color ?? HostColors.textPrimary,
        fontSize: context.sp(mobile: 14),
        fontWeight: FontWeight.w600,
      );

  static TextStyle drawerLogout(BuildContext context) => TextStyle(
    color: HostColors.redText,
    fontWeight: FontWeight.w600,
    fontSize: context.sp(mobile: 15),
  );
}
