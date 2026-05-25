import '../../core_import.dart';

@LazySingleton()
class UserSessionStorage {
  static const _kUid = 'FIREBASE_UID';
  static const _kUserId = 'USER_ID';
  static const _kOutletId = 'OUTLET_ID';
  static const _kOutletName = 'OUTLET_NAME';
  static const _kName = 'NAME';
  static const _kOutletAddress = 'OUTLET_ADDRESS';
  static const _kRole = 'USER_ROLE';
  static const _kRoleName = 'ROLE_NAME';
  static const _kPhone = 'USER_PHONE';
  static const _kDriverId = 'Driver Id';

  final SharedPreferences prefs;

  UserSessionStorage(this.prefs);

  Future<void> save(UserSessionModel session) async {
    await prefs.setString(_kUid, session.uid);
    await prefs.setInt(_kUserId, session.userId);

    if (session.outletId != null) {
      await prefs.setInt(_kOutletId, session.outletId!);
    } else {
      await prefs.remove(_kOutletId);
    }

    if (session.outletName != null) {
      await prefs.setString(_kOutletName, session.outletName!);
    } else {
      await prefs.remove(_kOutletName);
    }

    if (session.name != null) {
      await prefs.setString(_kName, session.name!);
    } else {
      await prefs.remove(_kName);
    }

    if (session.outletAddress != null) {
      await prefs.setString(_kOutletAddress, session.outletAddress!);
    } else {
      await prefs.remove(_kOutletAddress);
    }

    if (session.driverId != null) {
      await prefs.setInt(_kDriverId, session.driverId!);
    } else {
      await prefs.remove(_kDriverId);
    }

    await prefs.setString(_kRole, session.role.name);
    await prefs.setString(_kRoleName, session.roleName);
    await prefs.setString(_kPhone, session.phone);
  }

  UserSessionModel? read() {
    final uid = prefs.getString(_kUid);
    final userId = prefs.getInt(_kUserId);
    final roleRaw = prefs.getString(_kRole);
    final roleName = prefs.getString(_kRoleName);
    final phone = prefs.getString(_kPhone);

    if (uid == null ||
        userId == null ||
        roleRaw == null ||
        roleName == null ||
        phone == null) {
      AppLogger.log('❌ SESSION INVALID (missing core fields)');
      return null;
    }

    return UserSessionModel(
      uid: uid,
      userId: userId,
      outletId: prefs.getInt(_kOutletId),
      outletName: prefs.getString(_kOutletName),
      name: prefs.getString(_kName),
      outletAddress: prefs.getString(_kOutletAddress),
      role: UserRole.values.byName(roleRaw),
      roleName: roleName,
      phone: phone,
      driverId: prefs.getInt(_kDriverId),
    );
  }

  /// Quick access to just the Firebase UID — used by HomePage and blocs.
  String? get uid => prefs.getString(_kUid);

  Future<void> clear() async {
    await prefs.remove(_kUid);
    await prefs.remove(_kUserId);
    await prefs.remove(_kOutletId);
    await prefs.remove(_kOutletName);
    await prefs.remove(_kName);
    await prefs.remove(_kOutletAddress);
    await prefs.remove(_kRole);
    await prefs.remove(_kRoleName);
    await prefs.remove(_kPhone);
    await prefs.remove(_kDriverId);
  }
}
