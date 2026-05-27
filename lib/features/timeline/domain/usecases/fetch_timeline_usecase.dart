import '../../../../core_import.dart';

@injectable
class FetchTimelineUsecase {
  final TimelineRepository _repository;
  const FetchTimelineUsecase(this._repository);

  Future<ApiResult<List<TimelineItemEntity>>> call(
    FetchTimelineParams params,
  ) =>
      _repository.fetchTimelineItems(userId: params.userId);
}
