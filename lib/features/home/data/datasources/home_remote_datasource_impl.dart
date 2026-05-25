import 'dart:convert';
import '../../../../core_import.dart';

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl(this.firestore);

  @override
  Future<HomeDataDto> fetchHomeData(String userId) async {
    final profileDoc = await firestore.collection('profiles').doc(userId).get();
    final profileDto = UserProfileDto.fromFirestore(
      profileDoc.data() ?? {},
      profileDoc.id,
    );

    final recentLogSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    SymptomLogDto? recentLog;
    if (recentLogSnapshot.docs.isNotEmpty) {
      final doc = recentLogSnapshot.docs.first;
      recentLog = SymptomLogDto.fromFirestore(doc.data(), doc.id);
    }

    final recentRecordSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('health_records')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    HealthRecordDto? recentRecord;
    if (recentRecordSnapshot.docs.isNotEmpty) {
      final doc = recentRecordSnapshot.docs.first;
      recentRecord = HealthRecordDto.fromFirestore(doc.data(), doc.id);
    }

    final insightSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('insights')
        .orderBy('generatedDate', descending: true)
        .limit(1)
        .get();

    InsightDto? latestInsight;
    if (insightSnapshot.docs.isNotEmpty) {
      final doc = insightSnapshot.docs.first;
      latestInsight = InsightDto.fromFirestore(doc.data(), doc.id);
    }

    final reminderSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .where('scheduledAt', isGreaterThan: Timestamp.now())
        .orderBy('scheduledAt')
        .limit(1)
        .get();

    ReminderDto? reminder;
    if (reminderSnapshot.docs.isNotEmpty) {
      final doc = reminderSnapshot.docs.first;
      reminder = ReminderDto.fromFirestore(doc.data(), doc.id);
    }

    return HomeDataDto(
      profile: profileDto,
      recentLog: recentLog,
      recentRecord: recentRecord,
      latestInsight: latestInsight,
      reminder: reminder,
    );
  }

  @override
  Future<void> addSymptom({
    required String userId,
    required AddSymptomDto dto,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .add(dto.toFirestore());
  }

  @override
  Future<void> uploadRecord({
    required String userId,
    required UploadRecordDto dto,
    required List<int> fileBytes,
    required String mimeType,
  }) async {
    // 1. Encode the raw file bytes to a Base64 string.
    final fileData = base64Encode(fileBytes);

    // 2. Build the DTO with the actual encoded data.
    final dtoWithData = UploadRecordDto.fromEntity(
      UploadRecordEntity(
        title: dto.title,
        date: dto.date,
        recordType: dto.recordType,
        doctorOrClinic: dto.doctorOrClinic,
        notes: dto.notes,
        filePath: '', // No Storage path — file lives in Firestore
        fileName: dto.fileName,
      ),
      fileData: fileData,
      mimeType: mimeType,
    );

    // 3. Save everything (metadata + Base64 file) directly to Firestore.
    await firestore
        .collection('users')
        .doc(userId)
        .collection('health_records')
        .add(dtoWithData.toFirestore());
  }
}
