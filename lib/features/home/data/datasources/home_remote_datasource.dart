import '../../../../core_import.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataDto> fetchHomeData(String userId);

  Future<void> addSymptom({required String userId, required AddSymptomDto dto});

  /// Updates the symptom log document at [logId] in-place using Firestore's
  /// update() call. The document UID stays the same — no new doc is created.
  Future<void> updateSymptom({
    required String userId,
    required String logId,
    required AddSymptomDto dto,
  });

  /// Encodes [fileBytes] as Base64 and saves the health record directly
  /// into Firestore — no Firebase Storage required.
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

  // ── AI Insight ────────────────────────────────────────────────────────────

  /// Fetches the most recent 10 symptom logs for the log-selection page.
  Future<List<SymptomLogSummaryDto>> fetchSymptomLogs({required String userId});

  /// Calls the Anthropic Messages API with the log summaries, parses the
  /// JSON response, and returns a [AiInsightDto].
  /// The insight is also persisted to the user's `insights` Firestore collection.
  Future<AiInsightDto> generateAiInsight({
    required String userId,
    required List<SymptomLogSummaryDto> logDtos,
  });

  /// Saves a generated insight into the user's `timeline` Firestore collection.
  Future<void> saveInsightToTimeline({
    required String userId,
    required AiInsightDto dto,
  });
}
