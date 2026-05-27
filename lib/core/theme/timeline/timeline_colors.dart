import '../../../core_import.dart';

class TimelineColors {
  TimelineColors._();

  // ── Page scaffold ──────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF5F0EB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF0EBE5);

  // ── Track line ─────────────────────────────────────────────────────────────
  static const Color trackLine = Color(0xFFD9D2CA);

  // ── Filter chip ────────────────────────────────────────────────────────────
  static const Color chipBackground = Color(0xFFFFFFFF);
  static const Color chipBorder = Color(0xFFE2DAD4);
  static const Color chipSelectedBackground = Color(0xFF6B4FA0);
  static const Color chipSelectedText = Color(0xFFFFFFFF);
  static const Color chipUnselectedText = Color(0xFF5C4D3C);

  // ── Typography ─────────────────────────────────────────────────────────────
  static const Color titleText = Color(0xFF1E1A16);
  static const Color subtitleText = Color(0xFF8C7A6B);
  static const Color dateText = Color(0xFF8C7A6B);
  static const Color headlineText = Color(0xFF1E1A16);
  static const Color captionText = Color(0xFF8C7A6B);

  // ── Dot & icon colors per TimelineItemType ─────────────────────────────────
  static Color dotColor(TimelineItemType type) {
    switch (type) {
      case TimelineItemType.symptom:
        return const Color(0xFFE84E7A); // pink-red
      case TimelineItemType.record:
        return const Color(0xFF3CB96A); // green
      case TimelineItemType.aiInsight:
        return const Color(0xFF6B4FA0); // purple
      case TimelineItemType.doctorVisit:
        return const Color(0xFFE8973A); // amber-orange
    }
  }

  static Color iconColor(TimelineItemType type) => dotColor(type);
}
