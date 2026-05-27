import '../../../../../core_import.dart';

class FetchProfileParams {
  final String userId;
  const FetchProfileParams({required this.userId});
}

class UpdatePrivacyParams {
  final String userId;
  final PrivacySettingsEntity settings;
  const UpdatePrivacyParams({required this.userId, required this.settings});
}

class AddFamilyMemberParams {
  final String userId;
  final FamilyMemberEntity member;
  const AddFamilyMemberParams({required this.userId, required this.member});
}

class RemoveFamilyMemberParams {
  final String userId;
  final String memberId;
  const RemoveFamilyMemberParams({
    required this.userId,
    required this.memberId,
  });
}
