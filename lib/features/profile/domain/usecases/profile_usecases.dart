import '../../../../../core_import.dart';

class SaveProfileParams extends Equatable {
  final String uid;
  final String name;
  final String ageRange;
  final String lifeStage;
  final List<String> conditions;
  final String? medications;

  const SaveProfileParams({
    required this.uid,
    required this.name,
    required this.ageRange,
    required this.lifeStage,
    this.conditions = const [],
    this.medications,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    ageRange,
    lifeStage,
    conditions,
    medications,
  ];
}

@LazySingleton()
class SaveProfileUsecase implements BaseUseCase<void, SaveProfileParams> {
  final ProfileRepository repository;

  SaveProfileUsecase(this.repository);

  @override
  Future<ApiResult<void>> call(SaveProfileParams params) {
    return repository.saveProfile(
      UserProfileEntity(
        uid: params.uid,
        name: params.name,
        ageRange: params.ageRange,
        lifeStage: params.lifeStage,
        conditions: params.conditions,
        medications: params.medications,
      ),
    );
  }
}

@LazySingleton()
class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<ApiResult<UserProfileEntity?>> call(String uid) =>
      repository.getProfile(uid);
}
