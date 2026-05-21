import '../../../../core_import.dart';

@LazySingleton(as: UserRemoteDatasource)
class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final FirebaseFirestore firestore;

  UserRemoteDatasourceImpl(this.firestore);

  @override
  Future<UserDto?> checkUserExists(String userId) async {
    final document = await firestore.collection('users').doc(userId).get();

    if (!document.exists) {
      return null;
    }

    return UserDto.fromJson(document.data()!);
  }
}
