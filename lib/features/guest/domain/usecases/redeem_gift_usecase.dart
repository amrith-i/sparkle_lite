import '../../../../core_import.dart';

@lazySingleton
class RedeemGiftUsecase {
  final GiftRepository repository;

  RedeemGiftUsecase(this.repository);

  Future<GiftEntity?> call(RedeemGiftParams params) {
    return repository.redeemGift(params.qrToken, params.redeemedBy);
  }
}
