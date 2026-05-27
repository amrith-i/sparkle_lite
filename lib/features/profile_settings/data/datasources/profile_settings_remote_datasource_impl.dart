import '../../../../core_import.dart';

@LazySingleton(as: ProfileSettingsRemoteDataSource)
class ProfileSettingsRemoteDataSourceImpl
    implements ProfileSettingsRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileSettingsRemoteDataSourceImpl(this.firestore, this.auth);

  @override
  Future<ProfileSettingsEntity> fetchProfile(String userId) async {
    // Fetch profile, privacy settings, and family members concurrently
    final results = await Future.wait([
      firestore.collection('profiles').doc(userId).get(),
      firestore
          .collection('users')
          .doc(userId)
          .collection('privacy_settings')
          .doc('settings')
          .get(),
      firestore
          .collection('users')
          .doc(userId)
          .collection('family_members')
          .orderBy('createdAt', descending: false)
          .get(),
    ]);

    final profileDoc = results[0] as DocumentSnapshot<Map<String, dynamic>>;
    final privacyDoc = results[1] as DocumentSnapshot<Map<String, dynamic>>;
    final familySnap = results[2] as QuerySnapshot<Map<String, dynamic>>;

    final profileData = profileDoc.data() ?? {};
    final privacyData = privacyDoc.data() ?? {};

    final privacySettings = PrivacySettingsDto.fromFirestore(
      privacyData,
    ).toEntity();

    final familyMembers = familySnap.docs
        .map((d) => FamilyMemberDto.fromFirestore(d.data(), d.id).toEntity())
        .toList();

    // Get email from FirebaseAuth current user
    final email = auth.currentUser?.email ?? '';

    return ProfileSettingsEntity(
      uid: userId,
      name: profileData['name'] as String? ?? '',
      email: email,
      lifeStage: profileData['lifeStage'] as String? ?? 'General Wellness',
      privacySettings: privacySettings,
      familyMembers: familyMembers,
    );
  }

  @override
  Future<void> updatePrivacySettings({
    required String userId,
    required PrivacySettingsDto dto,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('privacy_settings')
        .doc('settings')
        .set(dto.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> addFamilyMember({
    required String userId,
    required FamilyMemberDto dto,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('family_members')
        .add(dto.toFirestore());
  }

  @override
  Future<void> removeFamilyMember({
    required String userId,
    required String memberId,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('family_members')
        .doc(memberId)
        .delete();
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }
}
