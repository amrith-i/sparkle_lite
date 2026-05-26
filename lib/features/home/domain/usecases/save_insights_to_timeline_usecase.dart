import '../../../../core_import.dart';

// ─── Params ───────────────────────────────────────────────────────────────────

class SaveInsightParams extends Equatable {
  final String userId;
  final AiInsightEntity insight;

  const SaveInsightParams({required this.userId, required this.insight});

  @override
  List<Object?> get props => [userId, insight];
}

// ─── Usecase ──────────────────────────────────────────────────────────────────

@injectable
class SaveInsightToTimelineUsecase {
  final HomeRepository repository;

  SaveInsightToTimelineUsecase(this.repository);

  Future<ApiResult<void>> call(SaveInsightParams params) {
    return repository.saveInsightToTimeline(
      userId: params.userId,
      insight: params.insight,
    );
  }
}
