import '../../core_import.dart';

class UserSessionModel {
  /// Firebase Auth UID — used for all Firestore queries.
  final String uid;

  /// Legacy int userId — kept for backward compatibility.
  final int userId;

  final int? outletId;
  final String? outletName;
  final String? name;
  final String? outletAddress;
  final UserRole role;
  final String roleName;
  final String phone;
  final int? driverId;

  const UserSessionModel({
    required this.uid,
    required this.userId,
    this.outletId,
    this.outletName,
    this.name,
    this.outletAddress,
    required this.role,
    required this.roleName,
    required this.phone,
    this.driverId,
  });
}
