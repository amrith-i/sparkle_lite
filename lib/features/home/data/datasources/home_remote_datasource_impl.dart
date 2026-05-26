import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core_import.dart';

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;
  final Dio dio;

  HomeRemoteDataSourceImpl(this.firestore, this.dio);

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

    // CHANGE THIS PART - Fetch upcoming doctor visits instead of reminders
    final now = DateTime.now();
    final upcomingVisitsSnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('doctor_visits')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('date')
        .limit(1)
        .get();

    ReminderDto? reminder;
    if (upcomingVisitsSnapshot.docs.isNotEmpty) {
      final doc = upcomingVisitsSnapshot.docs.first;
      final data = doc.data();
      // Convert doctor visit to reminder format
      reminder = ReminderDto(
        id: doc.id,
        title: 'Doctor Visit with ${data['doctorName'] ?? 'Doctor'}',
        scheduledAt: (data['date'] as Timestamp).toDate(),
      );
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
  Future<void> updateSymptom({
    required String userId,
    required String logId,
    required AddSymptomDto dto,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .doc(logId)
        .update(dto.toFirestoreForUpdate());
  }

  @override
  Future<void> uploadRecord({
    required String userId,
    required UploadRecordDto dto,
    required List<int> fileBytes,
    required String mimeType,
  }) async {
    final fileData = base64Encode(fileBytes);

    final dtoWithData = UploadRecordDto.fromEntity(
      UploadRecordEntity(
        title: dto.title,
        date: dto.date,
        recordType: dto.recordType,
        doctorOrClinic: dto.doctorOrClinic,
        notes: dto.notes,
        filePath: '',
        fileName: dto.fileName,
      ),
      fileData: fileData,
      mimeType: mimeType,
    );

    await firestore
        .collection('users')
        .doc(userId)
        .collection('health_records')
        .add(dtoWithData.toFirestore());
  }

  @override
  Future<void> addDoctorVisit({
    required String userId,
    required DoctorVisitDto dto,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('doctor_visits')
        .add(dto.toFirestore());
  }

  // ── AI Insight with Free Gemini API ─────────────────────────────────────────

  @override
  Future<List<SymptomLogSummaryDto>> fetchSymptomLogs({
    required String userId,
  }) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => SymptomLogSummaryDto.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<AiInsightDto> generateAiInsight({
    required String userId,
    required List<SymptomLogSummaryDto> logDtos,
  }) async {
    final logLines = logDtos.map((l) => l.toPromptString()).join('\n');

    final prompt =
        '''
You are a compassionate women's health assistant. Analyse the following period and symptom logs and return a JSON object with these exact keys:
- "summary": A 2-3 sentence plain-English summary of overall patterns.
- "patternNoticed": A 1-2 sentence description of the most notable pattern.
- "suggestedQuestions": A JSON array of 3 questions the user could ask their doctor.
- "whenToSeekCare": A 1-2 sentence recommendation on when professional care is warranted.

Respond ONLY with a valid JSON object. Do not include any preamble, markdown fences, or extra text.

Logs:
$logLines
''';

    // Use Groq API
    final responseText = await _callGroqApi(prompt);

    // Clean the response
    String clean = responseText
        .replaceAll(RegExp(r'```json|```'), '')
        .replaceAll(RegExp(r'^[\s\n]*'), '')
        .replaceAll(RegExp(r'[\s\n]*$'), '')
        .trim();

    final jsonStart = clean.indexOf('{');
    final jsonEnd = clean.lastIndexOf('}');
    if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
      clean = clean.substring(jsonStart, jsonEnd + 1);
    }

    final Map<String, dynamic> json = jsonDecode(clean) as Map<String, dynamic>;

    final logIds = logDtos.map((l) => l.id).toList();

    // Create DTO with Firestore timestamp
    final dto = AiInsightDto.fromAiJson(json, logIds);

    // Save to Firestore under users/{userId}/insights/
    final docRef = await firestore
        .collection('users')
        .doc(userId)
        .collection('insights')
        .add(dto.toFirestore());

    print(
      '✅ Insight saved to Firestore at: users/$userId/insights/${docRef.id}',
    );

    // Return DTO with the generated ID
    return AiInsightDto(
      id: docRef.id,
      summary: dto.summary,
      patternNoticed: dto.patternNoticed,
      suggestedQuestions: dto.suggestedQuestions,
      whenToSeekCare: dto.whenToSeekCare,
      generatedDate: dto.generatedDate,
      logIds: dto.logIds,
    );
  }

  @override
  Future<void> saveInsightToTimeline({
    required String userId,
    required AiInsightDto dto,
  }) async {
    // Save to timeline collection as well (for the user's timeline view)
    await firestore
        .collection('users')
        .doc(userId)
        .collection('timeline')
        .doc(dto.id)
        .set(dto.toFirestore());

    print('✅ Insight also saved to timeline: users/$userId/timeline/${dto.id}');
  }

  // Groq API implementation
  Future<String> _callGroqApi(String prompt) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GROQ_API_KEY not found. Get free key at: https://console.groq.com/',
      );
    }

    const apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

    try {
      print('🚀 Calling Groq API with llama-3.3-70b-versatile...');

      final response = await dio.post(
        apiUrl,
        data: {
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.5,
          'max_tokens': 800,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print('📡 Groq Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final text = data['choices']?[0]?['message']?['content'];

        if (text == null || text.isEmpty) {
          throw Exception('No text in Groq response');
        }

        print('✅ Groq success! Response length: ${text.length}');
        return text;
      } else {
        throw Exception(
          'Groq API error: ${response.statusCode} - ${response.data}',
        );
      }
    } on DioException catch (e) {
      print('❌ Groq DioException: ${e.message}');
      if (e.response != null) {
        print('❌ Response data: ${e.response?.data}');
        print('❌ Status code: ${e.response?.statusCode}');
      }
      rethrow;
    } catch (e) {
      print('❌ Groq Error: $e');
      rethrow;
    }
  }
}
