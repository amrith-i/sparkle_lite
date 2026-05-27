import '../../../../core_import.dart';

enum TimelineItemType { symptom, record, aiInsight, doctorVisit }

class TimelineItemEntity extends Equatable {
  final String id;
  final TimelineItemType type;
  final DateTime date;
  final String title;
  final String subtitle;

  const TimelineItemEntity({
    required this.id,
    required this.type,
    required this.date,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [id, type, date, title, subtitle];
}
