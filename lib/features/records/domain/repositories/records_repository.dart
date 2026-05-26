import '../../../../core_import.dart';

abstract class RecordsRepository {
  Future<ApiResult<List<HealthRecordEntity>>> fetchHealthRecords(String userId);

  Future<ApiResult<void>> deleteHealthRecord({
    required String userId,
    required String recordId,
  });
}
