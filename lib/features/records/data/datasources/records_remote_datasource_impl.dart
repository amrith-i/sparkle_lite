import '../../../../core_import.dart';

@LazySingleton(as: RecordsRemoteDataSource)
class RecordsRemoteDataSourceImpl implements RecordsRemoteDataSource {
  final FirebaseFirestore firestore;

  RecordsRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<HealthRecordDto>> fetchHealthRecords(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('health_records')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => HealthRecordDto.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> deleteHealthRecord({
    required String userId,
    required String recordId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('health_records')
        .doc(recordId)
        .delete();
  }
}
