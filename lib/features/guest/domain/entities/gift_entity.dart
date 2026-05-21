class GiftEntity {
  final String giftId;
  final String guestId;
  final String guestName;
  final String eventName;
  final String qrToken;
  final String status;

  final DateTime? unlockedAt;
  final DateTime? redeemedAt;

  final String? redeemedBy;

  GiftEntity({
    required this.giftId,
    required this.guestId,
    required this.guestName,
    required this.eventName,
    required this.qrToken,
    required this.status,
    this.unlockedAt,
    this.redeemedAt,
    this.redeemedBy,
  });
}
