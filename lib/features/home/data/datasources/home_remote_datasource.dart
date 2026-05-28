import '../../../../core_import.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataDto> fetchHomeData(String userId);

  Future<void> addSymptom({required String userId, required AddSymptomDto dto});

  Future<void> updateSymptom({
    required String userId,
    required String logId,
    required AddSymptomDto dto,
  });

  Future<void> uploadRecord({
    required String userId,
    required UploadRecordDto dto,
    required List<int> fileBytes,
    required String mimeType,
  });

  Future<void> addDoctorVisit({
    required String userId,
    required DoctorVisitDto dto,
  });

 
  Future<List<SymptomLogSummaryDto>> fetchSymptomLogs({required String userId});

  Future<AiInsightDto> generateAiInsight({
    required String userId,
    required List<SymptomLogSummaryDto> logDtos,
  });

  Future<void> saveInsightToTimeline({
    required String userId,
    required AiInsightDto dto,
  });
}
