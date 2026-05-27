import 'package:flutter/material.dart';
import 'timeline_colors.dart';

class TimelineTextStyles {
  TimelineTextStyles._();

  static TextStyle headline(BuildContext context) => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: TimelineColors.headlineText,
        letterSpacing: -0.5,
      );

  static TextStyle caption(BuildContext context) => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: TimelineColors.captionText,
      );

  static TextStyle cardTitle(BuildContext context) => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: TimelineColors.titleText,
      );

  static TextStyle cardSubtitle(BuildContext context) => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: TimelineColors.subtitleText,
      );

  static TextStyle cardDate(BuildContext context) => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: TimelineColors.dateText,
      );

  static TextStyle chipLabel(BuildContext context) => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      );
}
