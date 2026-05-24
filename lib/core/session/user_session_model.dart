import '../../core_import.dart';

class UserSessionModel {
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
