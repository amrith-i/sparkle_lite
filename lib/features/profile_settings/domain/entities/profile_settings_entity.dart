import '../../../../core_import.dart';

class ProfileSettingsEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String lifeStage; // shown as badge e.g. "Period Tracking"
  final PrivacySettingsEntity privacySettings;
  final List<FamilyMemberEntity> familyMembers;

  const ProfileSettingsEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.lifeStage,
    required this.privacySettings,
    required this.familyMembers,
  });

  ProfileSettingsEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? lifeStage,
    PrivacySettingsEntity? privacySettings,
    List<FamilyMemberEntity>? familyMembers,
  }) =>
      ProfileSettingsEntity(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        lifeStage: lifeStage ?? this.lifeStage,
        privacySettings: privacySettings ?? this.privacySettings,
        familyMembers: familyMembers ?? this.familyMembers,
      );

  @override
  List<Object?> get props =>
      [uid, name, email, lifeStage, privacySettings, familyMembers];
}
