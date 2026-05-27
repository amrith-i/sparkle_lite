import '../../../../core_import.dart';

abstract class ProfileSettingsEvent extends Equatable {
  const ProfileSettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfileSettings extends ProfileSettingsEvent {
  final String userId;
  const LoadProfileSettings({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class TogglePrivacySetting extends ProfileSettingsEvent {
  final String userId;
  final PrivacySettingField field;
  final bool value;
  const TogglePrivacySetting({
    required this.userId,
    required this.field,
    required this.value,
  });
  @override
  List<Object?> get props => [userId, field, value];
}

class AddFamilyMember extends ProfileSettingsEvent {
  final String userId;
  final FamilyMemberEntity member;
  const AddFamilyMember({required this.userId, required this.member});
  @override
  List<Object?> get props => [userId, member];
}

class RemoveFamilyMember extends ProfileSettingsEvent {
  final String userId;
  final String memberId;
  const RemoveFamilyMember({required this.userId, required this.memberId});
  @override
  List<Object?> get props => [userId, memberId];
}

class SignOutRequested extends ProfileSettingsEvent {
  const SignOutRequested();
}
