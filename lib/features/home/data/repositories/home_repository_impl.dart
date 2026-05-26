import '../../../../core_import.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(super.dio, {required this.remoteDataSource});

  @override
  Future<ApiResult<HomeDataEntity>> fetchHomeData(String userId) {
    return safeApiCall(() async {
      final dto = await remoteDataSource.fetchHomeData(userId);
      return dto.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> addSymptom({
    required String userId,
    required AddSymptomEntity entity,
  }) {
    return safeApiCall(() async {
      final dto = AddSymptomDto.fromEntity(entity);
      await remoteDataSource.addSymptom(userId: userId, dto: dto);
    });
  }

  @override
  Future<ApiResult<void>> updateSymptom({
    required String userId,
    required String logId,
    required AddSymptomEntity entity,
  }) {
    return safeApiCall(() async {
      final dto = AddSymptomDto.fromEntity(entity);
      await remoteDataSource.updateSymptom(
        userId: userId,
        logId: logId,
        dto: dto,
      );
    });
  }

  @override
  Future<ApiResult<void>> uploadRecord({
    required String userId,
    required UploadRecordEntity entity,
  }) {
    return safeApiCall(() async {
      final file = File(entity.filePath);
      final fileBytes = await file.readAsBytes();
      final mimeType = _resolveMimeType(entity.fileName);

      final dto = UploadRecordDto.fromEntity(
        entity,
        fileData: '',
        mimeType: mimeType,
      );

      await remoteDataSource.uploadRecord(
        userId: userId,
        dto: dto,
        fileBytes: fileBytes,
        mimeType: mimeType,
      );
    });
  }

  String _resolveMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Future<ApiResult<void>> addDoctorVisit({
    required String userId,
    required DoctorVisitEntity entity,
  }) {
    return safeApiCall(() async {
      final dto = DoctorVisitDto.fromEntity(entity);
      await remoteDataSource.addDoctorVisit(userId: userId, dto: dto);
    });
  }

  // ── AI Insight ──────────────────────────────────────────────────────────────

  @override
  Future<ApiResult<List<SymptomLogSummaryEntity>>> fetchSymptomLogs({
    required String userId,
  }) {
    return safeApiCall(() async {
      final dtos = await remoteDataSource.fetchSymptomLogs(userId: userId);
      return dtos.map((d) => d.toEntity()).toList();
    });
  }

  @override
  Future<ApiResult<AiInsightEntity>> generateAiInsight({
    required String userId,
    required List<SymptomLogSummaryEntity> selectedLogs,
  }) {
    return safeApiCall(() async {
      final logDtos = selectedLogs
          .map(
            (e) => SymptomLogSummaryDto(
              id: e.id,
              date: e.date,
              periodStatus: e.periodStatus,
              painLevel: e.painLevel,
              mood: e.mood,
            ),
          )
          .toList();

      final dto = await remoteDataSource.generateAiInsight(
        userId: userId,
        logDtos: logDtos,
      );
      return dto.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> saveInsightToTimeline({
    required String userId,
    required AiInsightEntity insight,
  }) {
    return safeApiCall(() async {
      final dto = AiInsightDto(
        id: insight.id,
        summary: insight.summary,
        patternNoticed: insight.patternNoticed,
        suggestedQuestions: insight.suggestedQuestions,
        whenToSeekCare: insight.whenToSeekCare,
        generatedDate: insight.generatedDate,
        logIds: insight.logIds,
      );
      await remoteDataSource.saveInsightToTimeline(userId: userId, dto: dto);
    });
  }
}
