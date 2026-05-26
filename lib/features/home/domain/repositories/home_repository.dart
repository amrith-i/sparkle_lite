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
}
