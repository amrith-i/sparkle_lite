import '../../../../core_import.dart';

abstract class TimelineRemoteDataSource {
  Future<List<TimelineItemDto>> fetchTimelineItems({required String userId});
}
