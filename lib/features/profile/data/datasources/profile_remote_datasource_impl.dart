import '../../../../core_import.dart';

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> saveProfile(Map<String, dynamic> data, String uid) => firestore
      .collection('profiles')
      .doc(uid)
      .set(data, SetOptions(merge: true));

  @override
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final doc = await firestore.collection('profiles').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }
}
