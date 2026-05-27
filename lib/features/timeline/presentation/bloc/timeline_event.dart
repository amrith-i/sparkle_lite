import '../../../../core_import.dart';

abstract class TimelineEvent extends Equatable {
  const TimelineEvent();
  @override
  List<Object?> get props => [];
}

class LoadTimeline extends TimelineEvent {
  final String userId;
  const LoadTimeline({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class RefreshTimeline extends TimelineEvent {
  final String userId;
  const RefreshTimeline({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class FilterTimeline extends TimelineEvent {
  final TimelineFilter filter;
  const FilterTimeline({required this.filter});
  @override
  List<Object?> get props => [filter];
}
