import '../../../../core_import.dart';

@LazySingleton(as: SymptomRepository)
class SymptomRepositoryImpl extends BaseRepository
    implements SymptomRepository {
  final SymptomRemoteDataSource remoteDataSource;

  SymptomRepositoryImpl(super.dio, {required this.remoteDataSource});

  @override
  Future<ApiResult<List<SymptomLogEntity>>> fetchSymptomLogs(
      String userId) {
    return safeApiCall(() async {
      final dtos = await remoteDataSource.fetchSymptomLogs(userId);
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<void>> deleteSymptomLog({
    required String userId,
    required String logId,
  }) {
    return safeApiCall(() async {
      await remoteDataSource.deleteSymptomLog(
        userId: userId,
        logId: logId,
      );
    });
  }
}
