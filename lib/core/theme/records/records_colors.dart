import 'package:flutter/material.dart';

abstract class RecordsColors {
  // ── Background & Surface ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF9F5F2);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);

  // ── Border ────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFE8E0DA);
  static const Color cardBorder = Color(0xFFF0E8E2);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D1F1A);
  static const Color textSecondary = Color(0xFF9E8B84);

  // ── Brand / Action ────────────────────────────────────────────────────────
  static const Color primaryRed = Color(0xFFE05C73);

  // ── Upload Button Gradient ────────────────────────────────────────────────
  static const List<Color> uploadBtnGradient = [
    Color(0xFFE05C73),
    Color(0xFFD94068),
  ];

  // ── Empty State ───────────────────────────────────────────────────────────
  static const Color emptyIconBg = Color(0xFFFCEEF0);

  // ── Record Type Tag Colors ────────────────────────────────────────────────
  // Lab Report
  static const Color labReportBg = Color(0xFFE8F4FD);
  static const Color labReportText = Color(0xFF2D7DD2);

  // Prescription
  static const Color prescriptionBg = Color(0xFFF0FAF0);
  static const Color prescriptionText = Color(0xFF2D8A4E);

  // Scan Report
  static const Color scanReportBg = Color(0xFFFFF3E8);
  static const Color scanReportText = Color(0xFFD4730A);

  // Doctor Visit Note
  static const Color doctorVisitNoteBg = Color(0xFFF3F0FC);
  static const Color doctorVisitNoteText = Color(0xFF6B4FBB);

  // Other
  static const Color otherBg = Color(0xFFF5F5F5);
  static const Color otherText = Color(0xFF757575);

  // ── Icon Container ────────────────────────────────────────────────────────
  static const Color iconContainerBg = Color(0xFFF9F5F2);

  // ── Delete Button ─────────────────────────────────────────────────────────
  static const Color deleteBtnBorder = Color(0xFFE05C73);
  static const Color deleteBtnText = Color(0xFFE05C73);
}
