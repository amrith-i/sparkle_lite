import '../../../../../core_import.dart';

class FetchProfileParams extends Equatable {
  final String userId;
  const FetchProfileParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdatePrivacyParams extends Equatable {
  final String userId;
  final PrivacySettingsEntity settings;
  const UpdatePrivacyParams({required this.userId, required this.settings});

  @override
  List<Object?> get props => [userId, settings];
}

class AddFamilyMemberParams extends Equatable {
  final String userId;
  final FamilyMemberEntity member;
  const AddFamilyMemberParams({required this.userId, required this.member});

  @override
  List<Object?> get props => [userId, member];
}

class RemoveFamilyMemberParams extends Equatable {
  final String userId;
  final String memberId;
  const RemoveFamilyMemberParams({
    required this.userId,
    required this.memberId,
  });

  @override
  List<Object?> get props => [userId, memberId];
}
