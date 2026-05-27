import '../../../../core_import.dart';

@injectable
class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  final FetchProfileSettingsUsecase _fetchProfileUsecase;
  final UpdatePrivacySettingsUsecase _updatePrivacyUsecase;
  final AddFamilyMemberUsecase _addFamilyMemberUsecase;
  final RemoveFamilyMemberUsecase _removeFamilyMemberUsecase;
  final SignOutUsecase _signOutUsecase;

  ProfileSettingsBloc(
    this._fetchProfileUsecase,
    this._updatePrivacyUsecase,
    this._addFamilyMemberUsecase,
    this._removeFamilyMemberUsecase,
    this._signOutUsecase,
  ) : super(ProfileSettingsInitial()) {
    on<LoadProfileSettings>(_onLoadProfile);
    on<TogglePrivacySetting>(_onTogglePrivacy);
    on<AddFamilyMember>(_onAddFamilyMember);
    on<RemoveFamilyMember>(_onRemoveFamilyMember);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onLoadProfile(
    LoadProfileSettings event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    emit(ProfileSettingsLoading());
    final result = await _fetchProfileUsecase(
      FetchProfileParams(userId: event.userId),
    );
    if (result.isSuccess) {
      emit(ProfileSettingsLoaded(result.data!));
    } else {
      emit(ProfileSettingsError(result.failure!.userMessage));
    }
  }

  Future<void> _onTogglePrivacy(
    TogglePrivacySetting event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    if (state is! ProfileSettingsLoaded) return;
    final current = (state as ProfileSettingsLoaded).profile;

    // Optimistically update UI first
    final updatedSettings = _applyToggle(
      current.privacySettings,
      event.field,
      event.value,
    );
    final updatedProfile = current.copyWith(privacySettings: updatedSettings);
    emit(ProfileSettingsLoaded(updatedProfile));

    // Persist to Firestore in background
    await _updatePrivacyUsecase(
      UpdatePrivacyParams(userId: event.userId, settings: updatedSettings),
    );
  }

  PrivacySettingsEntity _applyToggle(
    PrivacySettingsEntity settings,
    PrivacySettingField field,
    bool value,
  ) {
    switch (field) {
      case PrivacySettingField.hideSensitiveDashboard:
        return settings.copyWith(hideSensitiveDashboard: value);
      case PrivacySettingField.genericNotificationText:
        return settings.copyWith(genericNotificationText: value);
      case PrivacySettingField.confirmBeforeSharingRecords:
        return settings.copyWith(confirmBeforeSharingRecords: value);
      case PrivacySettingField.allowFamilyProfileAccess:
        return settings.copyWith(allowFamilyProfileAccess: value);
    }
  }

  Future<void> _onAddFamilyMember(
    AddFamilyMember event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    if (state is! ProfileSettingsLoaded) return;
    final current = (state as ProfileSettingsLoaded).profile;
    emit(FamilyMemberAdding(current));

    final result = await _addFamilyMemberUsecase(
      AddFamilyMemberParams(userId: event.userId, member: event.member),
    );

    if (result.isSuccess) {
      // Re-fetch to get the server-assigned ID
      final refreshed = await _fetchProfileUsecase(
        FetchProfileParams(userId: event.userId),
      );
      if (refreshed.isSuccess) {
        emit(FamilyMemberAddSuccess(refreshed.data!));
      } else {
        emit(FamilyMemberAddSuccess(current));
      }
    } else {
      emit(FamilyMemberAddFailure(current, result.failure!.userMessage));
    }
  }

  Future<void> _onRemoveFamilyMember(
    RemoveFamilyMember event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    if (state is! ProfileSettingsLoaded) return;
    final current = (state as ProfileSettingsLoaded).profile;

    // Optimistically remove from list
    final updated = current.copyWith(
      familyMembers: current.familyMembers
          .where((m) => m.id != event.memberId)
          .toList(),
    );
    emit(FamilyMemberRemoving(updated));

    final result = await _removeFamilyMemberUsecase(
      RemoveFamilyMemberParams(userId: event.userId, memberId: event.memberId),
    );

    if (result.isSuccess) {
      // Re-fetch to ensure data consistency
      final refreshed = await _fetchProfileUsecase(
        FetchProfileParams(userId: event.userId),
      );
      if (refreshed.isSuccess) {
        emit(FamilyMemberRemoveSuccess(refreshed.data!));
      } else {
        emit(FamilyMemberRemoveSuccess(updated));
      }
    } else {
      emit(FamilyMemberRemoveFailure(updated, result.failure!.userMessage));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<ProfileSettingsState> emit,
  ) async {
    final result = await _signOutUsecase();
    if (result.isSuccess) {
      emit(SignOutSuccess());
    } else {
      emit(SignOutFailure(result.failure!.userMessage));
    }
  }
}
