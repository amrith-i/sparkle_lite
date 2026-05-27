import 'package:flutter/material.dart';
import 'timeline_colors.dart';

class TimelineDecorations {
  TimelineDecorations._();

  static BoxDecoration card() => BoxDecoration(
        color: TimelineColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TimelineColors.cardBorder, width: 1),
      );

  static BoxDecoration chipSelected() => BoxDecoration(
        color: TimelineColors.chipSelectedBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: TimelineColors.chipSelectedBackground,
          width: 1.5,
        ),
      );

  static BoxDecoration chipUnselected() => BoxDecoration(
        color: TimelineColors.chipBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TimelineColors.chipBorder, width: 1.5),
      );
}
