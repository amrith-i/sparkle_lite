abstract class GiftEvent {}

class GetGiftEvent extends GiftEvent {
  final String userId;
  GetGiftEvent(this.userId);
}

// gift_event.dart — add userId to UnlockGiftEvent
class UnlockGiftEvent extends GiftEvent {
  final String giftId;
  final String userId; // add this

  UnlockGiftEvent(this.giftId, this.userId); // add this
}

class RedeemGiftEvent extends GiftEvent {
  final String qrToken;
  final String redeemedBy;
  RedeemGiftEvent({required this.qrToken, required this.redeemedBy});
}

class CheckGiftStatusEvent extends GiftEvent {
  final String qrToken;
  CheckGiftStatusEvent(this.qrToken);
}
