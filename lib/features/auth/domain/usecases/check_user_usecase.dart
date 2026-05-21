import '../../../../core_import.dart';

@lazySingleton
class CheckUserUsecase {
  final UserRepository repository;

  CheckUserUsecase(this.repository);

  Future<UserEntity?> call(CheckUserParams params) async {
    return await repository.checkUserExists(params.userId);
  }
}
