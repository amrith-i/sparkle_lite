import '../../../../core_import.dart';

@lazySingleton
class UnlockGiftUsecase {
  final GiftRepository repository;

  UnlockGiftUsecase(this.repository);

  Future<GiftEntity?> call(String giftId) {
    return repository.unlockGift(giftId);
  }
}
