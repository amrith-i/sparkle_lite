import '../../../../core_import.dart';

@lazySingleton
class GetGiftByTokenUsecase {
  final GiftRepository repository;

  GetGiftByTokenUsecase(this.repository);

  Future<GiftEntity?> call(String qrToken) {
    return repository.getGiftByToken(qrToken);
  }
}
