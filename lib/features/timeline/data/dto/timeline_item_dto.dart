import '../../../../core_import.dart';

class TimelineItemDto {
  final String id;
  final TimelineItemType type;
  final DateTime date;
  final String title;
  final String subtitle;

  const TimelineItemDto({
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  TimelineItemEntity toEntity() => TimelineItemEntity(
        id: id,
        type: type,
        date: date,
        title: title,
        subtitle: subtitle,
      );
}
