import '../../../../core_import.dart';

@LazySingleton(as: RecordsRepository)
class RecordsRepositoryImpl extends BaseRepository
    implements RecordsRepository {
  final RecordsRemoteDataSource remoteDataSource;

  RecordsRepositoryImpl(super.dio, {required this.remoteDataSource});

  @override
  Future<ApiResult<List<HealthRecordEntity>>> fetchHealthRecords(
    String userId,
  ) {
    return safeApiCall(() async {
      final dtos = await remoteDataSource.fetchHealthRecords(userId);
      return dtos.map((dto) => dto.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<void>> deleteHealthRecord({
    required String userId,
    required String recordId,
  }) {
    return safeApiCall(() async {
      await remoteDataSource.deleteHealthRecord(
        userId: userId,
        recordId: recordId,
      );
    });
  }
}
