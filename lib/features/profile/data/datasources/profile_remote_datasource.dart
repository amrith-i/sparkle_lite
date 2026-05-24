import '../../../../../core_import.dart';

abstract class ProfileRemoteDataSource {
  Future<void> saveProfile(Map<String, dynamic> data, String uid);
  Future<Map<String, dynamic>?> getProfile(String uid);
}


