import '../../../../core_import.dart';

enum TimelineFilter { all, symptoms, records, aiInsights, doctorVisit }

abstract class TimelineState extends Equatable {
  const TimelineState();
  @override
  List<Object?> get props => [];
}

class TimelineInitial extends TimelineState {}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<TimelineItemEntity> allItems;
  final TimelineFilter activeFilter;

  const TimelineLoaded({required this.allItems, required this.activeFilter});

  List<TimelineItemEntity> get filteredItems {
    switch (activeFilter) {
      case TimelineFilter.all:
        return allItems;
      case TimelineFilter.symptoms:
        return allItems
            .where((i) => i.type == TimelineItemType.symptom)
            .toList();
      case TimelineFilter.records:
        return allItems
            .where((i) => i.type == TimelineItemType.record)
            .toList();
      case TimelineFilter.aiInsights:
        return allItems
            .where((i) => i.type == TimelineItemType.aiInsight)
            .toList();
      case TimelineFilter.doctorVisit:
        return allItems
            .where((i) => i.type == TimelineItemType.doctorVisit)
            .toList();
    }
  }

  TimelineLoaded copyWith({
    List<TimelineItemEntity>? allItems,
    TimelineFilter? activeFilter,
  }) => TimelineLoaded(
    allItems: allItems ?? this.allItems,
    activeFilter: activeFilter ?? this.activeFilter,
  );

  @override
  List<Object?> get props => [allItems, activeFilter];
}

class TimelineError extends TimelineState {
  final String message;
  const TimelineError(this.message);
  @override
  List<Object?> get props => [message];
}
