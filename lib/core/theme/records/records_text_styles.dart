import 'package:flutter/material.dart';
import '../../../../core_import.dart';

abstract class RecordsTextStyles {
  // ── Page Header ───────────────────────────────────────────────────────────
  static TextStyle pageTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 26),
    fontWeight: FontWeight.w700,
    color: RecordsColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle pageSubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: RecordsColors.textSecondary,
  );

  // ── Record Count ──────────────────────────────────────────────────────────
  static TextStyle recordCount(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    color: RecordsColors.textSecondary,
  );

  // ── Filter Chip ───────────────────────────────────────────────────────────
  static TextStyle filterChipLabel(
    BuildContext context, {
    required bool selected,
  }) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
    color: selected ? RecordsColors.primaryRed : RecordsColors.textSecondary,
  );

  // ── Card ──────────────────────────────────────────────────────────────────
  static TextStyle cardTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w600,
    color: RecordsColors.textPrimary,
  );

  static TextStyle cardMeta(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 12),
    fontWeight: FontWeight.w400,
    color: RecordsColors.textSecondary,
  );

  static TextStyle cardNotes(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: RecordsColors.textSecondary,
  );

  static TextStyle tagText(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 11),
    fontWeight: FontWeight.w500,
  );

  // ── Delete Button ─────────────────────────────────────────────────────────
  static TextStyle deleteBtn(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 13),
    fontWeight: FontWeight.w500,
    color: RecordsColors.deleteBtnText,
  );

  // ── Empty State ───────────────────────────────────────────────────────────
  static TextStyle emptyTitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 20),
    fontWeight: FontWeight.w700,
    color: RecordsColors.textPrimary,
  );

  static TextStyle emptySubtitle(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 14),
    fontWeight: FontWeight.w400,
    color: RecordsColors.textSecondary,
  );

  // ── Upload Button ─────────────────────────────────────────────────────────
  static TextStyle uploadBtn(BuildContext context) => TextStyle(
    fontSize: context.sp(mobile: 15),
    fontWeight: FontWeight.w600,
    color: RecordsColors.white,
  );
}
