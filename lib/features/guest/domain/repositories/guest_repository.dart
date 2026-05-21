import '../../../../core_import.dart';

abstract class GiftRepository {
  Future<GiftEntity?> getGift(String guestId);

  Future<GiftEntity?> unlockGift(String giftId);

  Future<GiftEntity?> redeemGift(String qrToken, String redeemedBy);

  Future<GiftEntity?> getGiftByToken(String qrToken);
}
