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
  Future<ApiResult<void>> uploadRecord({
    required String userId,
    required UploadRecordEntity entity,
  }) {
    return safeApiCall(() async {
      // Read file bytes from the local path picked by FilePicker
      final file = File(entity.filePath);
      final fileBytes = await file.readAsBytes();
      final mimeType = _resolveMimeType(entity.fileName);

      final dto = UploadRecordDto.fromEntity(
        entity,
        fileData: '', // Placeholder — Base64 encoding happens in the datasource
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
}
