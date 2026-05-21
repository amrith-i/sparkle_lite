import 'package:flutter/material.dart';
import '../../../core_import.dart';
import 'guest_colors.dart';

abstract final class GuestDecorations {
  static BoxDecoration headerIconCircle() => BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    shape: BoxShape.circle,
  );

  static BorderRadius cardRadius(BuildContext context) =>
      BorderRadius.circular(context.r(mobile: 20));

  static BoxDecoration statusPill(BuildContext context, String status) =>
      BoxDecoration(
        color: status == 'locked'
            ? GuestColors.lockedBg
            : status == 'unlocked'
            ? GuestColors.unlockedBg
            : GuestColors.redeemedPillBg,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
      );

  static const BoxDecoration goldGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        GuestColors.goldStart,
        GuestColors.goldMid1,
        GuestColors.goldMid2,
        GuestColors.goldEnd,
      ],
      stops: [0.0, 0.4, 0.7, 1.0],
    ),
  );

  static RoundedRectangleBorder shareButtonShape(BuildContext context) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 14)),
      );

  static BoxDecoration drawerIconBox(BuildContext context) => BoxDecoration(
    color: GuestColors.surface,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
  );
}
