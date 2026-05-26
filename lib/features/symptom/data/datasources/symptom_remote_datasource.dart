import '../../../../core_import.dart';

abstract class SymptomRemoteDataSource {
  Future<List<SymptomLogDto>> fetchSymptomLogs(String userId);

  Future<void> deleteSymptomLog({
    required String userId,
    required String logId,
  });
}
