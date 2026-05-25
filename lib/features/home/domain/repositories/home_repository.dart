import '../../../../core_import.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeDataEntity>> fetchHomeData(String userId);

  Future<ApiResult<void>> addSymptom({
    required String userId,
    required AddSymptomEntity entity,
  });

  Future<ApiResult<void>> uploadRecord({
    required String userId,
    required UploadRecordEntity entity,
  });
}
