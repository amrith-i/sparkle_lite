import '../../../../core_import.dart';

@LazySingleton(as: SymptomRemoteDataSource)
class SymptomRemoteDataSourceImpl implements SymptomRemoteDataSource {
  final FirebaseFirestore firestore;

  SymptomRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<SymptomLogDto>> fetchSymptomLogs(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SymptomLogDto.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> deleteSymptomLog({
    required String userId,
    required String logId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('symptom_logs')
        .doc(logId)
        .delete();
  }
}
