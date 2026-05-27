import '../../../../core_import.dart';

// ── Fetch profile ─────────────────────────────────────────────────────────────

@injectable
class FetchProfileSettingsUsecase {
  final ProfileSettingsRepository _repository;
  const FetchProfileSettingsUsecase(this._repository);

  Future<ApiResult<ProfileSettingsEntity>> call(FetchProfileParams params) =>
      _repository.fetchProfile(params.userId);
}

// ── Update privacy settings ───────────────────────────────────────────────────

@injectable
class UpdatePrivacySettingsUsecase {
  final ProfileSettingsRepository _repository;
  const UpdatePrivacySettingsUsecase(this._repository);

  Future<ApiResult<void>> call(UpdatePrivacyParams params) =>
      _repository.updatePrivacySettings(
        userId: params.userId,
        settings: params.settings,
      );
}

// ── Add family member ─────────────────────────────────────────────────────────

@injectable
class AddFamilyMemberUsecase {
  final ProfileSettingsRepository _repository;
  const AddFamilyMemberUsecase(this._repository);

  Future<ApiResult<void>> call(AddFamilyMemberParams params) =>
      _repository.addFamilyMember(
        userId: params.userId,
        member: params.member,
      );
}

// ── Remove family member ──────────────────────────────────────────────────────

@injectable
class RemoveFamilyMemberUsecase {
  final ProfileSettingsRepository _repository;
  const RemoveFamilyMemberUsecase(this._repository);

  Future<ApiResult<void>> call(RemoveFamilyMemberParams params) =>
      _repository.removeFamilyMember(
        userId: params.userId,
        memberId: params.memberId,
      );
}

// ── Sign out ──────────────────────────────────────────────────────────────────

@injectable
class SignOutUsecase {
  final ProfileSettingsRepository _repository;
  const SignOutUsecase(this._repository);

  Future<ApiResult<void>> call() => _repository.signOut();
}
