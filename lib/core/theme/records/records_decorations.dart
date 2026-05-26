import 'package:flutter/material.dart';
import '../../../../core_import.dart';

abstract class RecordsDecorations {
  // ── Card ──────────────────────────────────────────────────────────────────
  static BoxDecoration card(BuildContext context) => BoxDecoration(
    color: RecordsColors.cardSurface,
    borderRadius: BorderRadius.circular(context.r(mobile: 16)),
    border: Border.all(color: RecordsColors.cardBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF2D1F1A).withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // ── Filter Chip — Selected ────────────────────────────────────────────────
  static BoxDecoration filterChipSelected(BuildContext context) =>
      BoxDecoration(
        color: RecordsColors.white,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
        border: Border.all(color: RecordsColors.primaryRed, width: 1.5),
      );

  // ── Filter Chip — Unselected ──────────────────────────────────────────────
  static BoxDecoration filterChipUnselected(BuildContext context) =>
      BoxDecoration(
        color: RecordsColors.white,
        borderRadius: BorderRadius.circular(context.r(mobile: 20)),
        border: Border.all(color: RecordsColors.border, width: 1),
      );

  // ── Icon Container ────────────────────────────────────────────────────────
  static BoxDecoration iconContainer(BuildContext context) => BoxDecoration(
    color: RecordsColors.iconContainerBg,
    borderRadius: BorderRadius.circular(context.r(mobile: 12)),
  );
}
