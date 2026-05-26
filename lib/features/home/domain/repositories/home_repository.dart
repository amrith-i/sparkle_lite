import '../../../../core_import.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeDataEntity>> fetchHomeData(String userId);

  Future<ApiResult<void>> addSymptom({
    required String userId,
    required AddSymptomEntity entity,
  });

  /// Updates an existing symptom log document at [logId].
  /// The Firestore document UID is preserved — no new document is created.
  Future<ApiResult<void>> updateSymptom({
    required String userId,
    required String logId,
    required AddSymptomEntity entity,
  });

  Future<ApiResult<void>> uploadRecord({
    required String userId,
    required UploadRecordEntity entity,
  });

  Future<ApiResult<void>> addDoctorVisit({
    required String userId,
    required DoctorVisitEntity entity,
  });

  Future<ApiResult<List<SymptomLogSummaryEntity>>> fetchSymptomLogs({
    required String userId,
  });

  /// Calls the Anthropic API with the selected symptom logs and returns the
  /// parsed insight. Also persists the result in Firestore.
  Future<ApiResult<AiInsightEntity>> generateAiInsight({
    required String userId,
    required List<SymptomLogSummaryEntity> selectedLogs,
  });

  /// Saves a previously generated insight to the user's timeline collection.
  Future<ApiResult<void>> saveInsightToTimeline({
    required String userId,
    required AiInsightEntity insight,
  });
}
