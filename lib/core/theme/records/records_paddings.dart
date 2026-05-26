import 'package:flutter/material.dart';
import '../../../../core_import.dart';

abstract class RecordsPaddings {
  // ── Page ──────────────────────────────────────────────────────────────────
  static EdgeInsets pagePadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 20),
  );

  // ── Card ──────────────────────────────────────────────────────────────────
  static EdgeInsets cardPadding(BuildContext context) => EdgeInsets.all(
    context.w(mobile: 16),
  );

  // ── Filter Chip ───────────────────────────────────────────────────────────
  static EdgeInsets chipPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 14),
    vertical: context.h(mobile: 8),
  );

  // ── Tag ───────────────────────────────────────────────────────────────────
  static EdgeInsets tagPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 10),
    vertical: context.h(mobile: 4),
  );

  // ── Icon Container ────────────────────────────────────────────────────────
  static EdgeInsets iconContainerPadding(BuildContext context) => EdgeInsets.all(
    context.w(mobile: 10),
  );
}
