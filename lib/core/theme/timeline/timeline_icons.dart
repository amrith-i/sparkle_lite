import '../../../core_import.dart';

class TimelineIcons {
  TimelineIcons._();

  /// Returns a widget icon for each timeline item type.
  static Widget icon(TimelineItemType type, {double size = 20}) {
    switch (type) {
      case TimelineItemType.symptom:
        return Text('🌸', style: TextStyle(fontSize: size));
      case TimelineItemType.record:
        return Text('📁', style: TextStyle(fontSize: size));
      case TimelineItemType.aiInsight:
        return Icon(
          Icons.auto_awesome,
          size: size,
          color: TimelineColors.iconColor(type),
        );
      case TimelineItemType.doctorVisit:
        return Icon(
          Icons.medical_services_outlined,
          size: size,
          color: TimelineColors.iconColor(type),
        );
    }
  }
}
