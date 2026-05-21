import 'package:flutter/material.dart';
import '../../../core_import.dart';
import 'host_colors.dart';

abstract final class HostDecorations {
  static BoxDecoration scannerBox(BuildContext context) => BoxDecoration(
    color: HostColors.surface,
    borderRadius: BorderRadius.circular(context.r(mobile: 24)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BorderRadius scannerClip(BuildContext context) =>
      BorderRadius.circular(context.r(mobile: 24));

  static BoxDecoration greenCard(BuildContext context) => BoxDecoration(
    color: HostColors.greenBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 18)),
    border: Border.all(color: HostColors.greenBorder, width: 1.2),
  );

  static BoxDecoration redCard(BuildContext context) => BoxDecoration(
    color: HostColors.redBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 18)),
    border: Border.all(color: HostColors.redBorder, width: 1.2),
  );

  static BoxDecoration idleCard(BuildContext context) => BoxDecoration(
    color: HostColors.idleBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 18)),
    border: Border.all(color: HostColors.idleBorder, width: 1.2),
  );

  static BoxDecoration cardIconBox(BuildContext context) => BoxDecoration(
    color: HostColors.surface,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
  );

  static BoxDecoration badge(BuildContext context, Color bg) => BoxDecoration(
    color: bg,
    borderRadius: BorderRadius.circular(context.r(mobile: 20)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration dialogIconCircle(Color bg) =>
      BoxDecoration(color: bg, shape: BoxShape.circle);

  static RoundedRectangleBorder buttonShape(BuildContext context) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 16)),
      );

  static RoundedRectangleBorder dialogButtonShape(BuildContext context) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 12)),
      );

  static BoxDecoration drawerAvatarIcon(BuildContext context) => BoxDecoration(
    color: HostColors.surface,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
  );
}
