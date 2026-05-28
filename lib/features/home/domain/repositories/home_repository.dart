import '../../../../core_import.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeDataEntity>> fetchHomeData(String userId);

  Future<ApiResult<void>> addSymptom({
    required String userId,
    required AddSymptomEntity entity,
  });

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

  Future<ApiResult<AiInsightEntity>> generateAiInsight({
    required String userId,
    required List<SymptomLogSummaryEntity> selectedLogs,
  });

  Future<ApiResult<void>> saveInsightToTimeline({
    required String userId,
    required AiInsightEntity insight,
  });
}
