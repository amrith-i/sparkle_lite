import '../../../../core_import.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataDto> fetchHomeData(String userId);

  Future<void> addSymptom({required String userId, required AddSymptomDto dto});

  /// Encodes [fileBytes] as Base64 and saves the health record directly
  /// into Firestore — no Firebase Storage required.
  Future<void> uploadRecord({
    required String userId,
    required UploadRecordDto dto,
    required List<int> fileBytes,
    required String mimeType,
  });
}
