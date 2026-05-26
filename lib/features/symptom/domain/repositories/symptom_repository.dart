import '../../../../core_import.dart';

abstract class SymptomRepository {
  Future<ApiResult<List<SymptomLogEntity>>> fetchSymptomLogs(String userId);

  Future<ApiResult<void>> deleteSymptomLog({
    required String userId,
    required String logId,
  });
}
