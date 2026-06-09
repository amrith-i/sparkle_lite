import '../../../../core_import.dart';

enum PrivacySettingField {
  hideSensitiveDashboard,
  genericNotificationText,
  confirmBeforeSharingRecords,
  allowFamilyProfileAccess,
}

abstract class ProfileSettingsState extends Equatable {
  const ProfileSettingsState();
  @override
  List<Object?> get props => [];
}

class ProfileSettingsInitial extends ProfileSettingsState {}

class ProfileSettingsLoading extends ProfileSettingsState {}

class ProfileSettingsLoaded extends ProfileSettingsState {
  final ProfileSettingsEntity profile;

  const ProfileSettingsLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileSettingsError extends ProfileSettingsState {
  final String message;
  const ProfileSettingsError(this.message);
  @override
  List<Object?> get props => [message];
}

class FamilyMemberAdding extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  const FamilyMemberAdding(this.profile);
  @override
  List<Object?> get props => [profile];
}

class FamilyMemberAddSuccess extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  const FamilyMemberAddSuccess(this.profile);
  @override
  List<Object?> get props => [profile];
}

class FamilyMemberAddFailure extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  final String message;
  const FamilyMemberAddFailure(this.profile, this.message);
  @override
  List<Object?> get props => [profile, message];
}

class FamilyMemberRemoving extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  const FamilyMemberRemoving(this.profile);
  @override
  List<Object?> get props => [profile];
}

// Add these missing states
class FamilyMemberRemoveSuccess extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  const FamilyMemberRemoveSuccess(this.profile);
  @override
  List<Object?> get props => [profile];
}

class FamilyMemberRemoveFailure extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  final String message;
  const FamilyMemberRemoveFailure(this.profile, this.message);
  @override
  List<Object?> get props => [profile, message];
}

class SignOutSuccess extends ProfileSettingsState {}

class SignOutFailure extends ProfileSettingsState {
  final String message;
  const SignOutFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class FamilyMemberUpdating extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  const FamilyMemberUpdating({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class FamilyMemberUpdateSuccess extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  const FamilyMemberUpdateSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class FamilyMemberUpdateFailure extends ProfileSettingsState {
  final ProfileSettingsEntity profile;
  final String message;
  const FamilyMemberUpdateFailure({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}
