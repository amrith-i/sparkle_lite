import '../../../../core_import.dart';

abstract class TimelineRepository {
  Future<ApiResult<List<TimelineItemEntity>>> fetchTimelineItems({
    required String userId,
  });
}
