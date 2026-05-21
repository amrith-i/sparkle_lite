import '../../../../core_import.dart';

@lazySingleton
class GetGiftUsecase {
  final GiftRepository repository;

  GetGiftUsecase(this.repository);

  Future<GiftEntity?> call(String guestId) {
    return repository.getGift(guestId);
  }
}
