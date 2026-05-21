import '../../../../core_import.dart';

@LazySingleton(as: GiftRepository)
class GiftRepositoryImpl implements GiftRepository {
  final GiftRemoteDatasource datasource;

  GiftRepositoryImpl(this.datasource);

  @override
  Future<GiftEntity?> getGift(String guestId) {
    return datasource.getGift(guestId);
  }

  @override
  Future<GiftEntity?> unlockGift(String giftId) {
    return datasource.unlockGift(giftId);
  }

  @override
  Future<GiftEntity?> redeemGift(String qrToken, String redeemedBy) {
    return datasource.redeemGift(qrToken, redeemedBy);
  }

  @override
  Future<GiftEntity?> getGiftByToken(String qrToken) {
    return datasource.getGiftByToken(qrToken);
  }
}
