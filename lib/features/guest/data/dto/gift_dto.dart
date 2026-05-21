import '../../../../core_import.dart';

class GiftDto extends GiftEntity {
  GiftDto({
    required super.giftId,
    required super.guestId,
    required super.guestName,
    required super.eventName,
    required super.qrToken,
    required super.status,
    super.unlockedAt,
    super.redeemedAt,
    super.redeemedBy,
  });

  factory GiftDto.fromJson(Map<String, dynamic> json) {
    return GiftDto(
      giftId: json['giftId'] ?? '',
      guestId: json['guestId'] ?? '',
      guestName: json['guestName'] ?? '',
      eventName: json['eventName'] ?? '',
      qrToken: json['qrToken'] ?? '',
      status: json['status'] ?? '',
      redeemedBy: json['redeemedBy'],
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      redeemedAt: json['redeemedAt'] != null
          ? DateTime.parse(json['redeemedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "giftId": giftId,
      "guestId": guestId,
      "guestName": guestName,
      "eventName": eventName,
      "qrToken": qrToken,
      "status": status,
      "unlockedAt": unlockedAt?.toIso8601String(),
      "redeemedAt": redeemedAt?.toIso8601String(),
      "redeemedBy": redeemedBy,
    };
  }
}
