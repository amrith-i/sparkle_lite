import '../../../../core_import.dart';

@LazySingleton(as: TimelineRepository)
class TimelineRepositoryImpl extends BaseRepository
    implements TimelineRepository {
  final TimelineRemoteDataSource remoteDataSource;

  TimelineRepositoryImpl(super.dio, {required this.remoteDataSource});

  @override
  Future<ApiResult<List<TimelineItemEntity>>> fetchTimelineItems({
    required String userId,
  }) {
    return safeApiCall(() async {
      final dtos = await remoteDataSource.fetchTimelineItems(userId: userId);
      return dtos.map((d) => d.toEntity()).toList();
    });
  }
}
