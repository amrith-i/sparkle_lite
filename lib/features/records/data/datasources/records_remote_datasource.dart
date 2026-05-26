import '../../../../core_import.dart';

abstract class RecordsRemoteDataSource {
  Future<List<HealthRecordDto>> fetchHealthRecords(String userId);

  Future<void> deleteHealthRecord({
    required String userId,
    required String recordId,
  });
}
