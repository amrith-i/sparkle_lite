import '../../../../core_import.dart';

@LazySingleton(as: GiftRemoteDatasource)
class GiftRemoteDatasourceImpl implements GiftRemoteDatasource {
  final FirebaseFirestore firestore;

  GiftRemoteDatasourceImpl(this.firestore);

  @override
  Future<GiftEntity?> getGift(String guestId) async {
    final snapshot = await firestore
        .collection("gifts")
        .where("guestId", isEqualTo: guestId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final data = snapshot.docs.first.data();

    return GiftDto.fromJson(data);
  }

  @override
  Future<GiftEntity?> unlockGift(String giftId) async {
    await firestore.collection("gifts").doc(giftId).update({
      "status": "unlocked",
      "unlockedAt": DateTime.now().toIso8601String(),
    });

    final updatedDoc = await firestore.collection("gifts").doc(giftId).get();

    return GiftDto.fromJson(updatedDoc.data()!);
  }

  @override
  Future<GiftEntity?> redeemGift(String qrToken, String redeemedBy) async {
    final snapshot = await firestore
        .collection("gifts")
        .where("qrToken", isEqualTo: qrToken)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    final data = doc.data();

    if (data["status"] == "redeemed") {
      return null;
    }

    await firestore.collection("gifts").doc(doc.id).update({
      "status": "redeemed",
      "redeemedBy": redeemedBy,
      "redeemedAt": DateTime.now().toIso8601String(),
    });

    final updatedDoc = await firestore.collection("gifts").doc(doc.id).get();

    return GiftDto.fromJson(updatedDoc.data()!);
  }

  @override
  Future<GiftEntity?> getGiftByToken(String qrToken) async {
    final snapshot = await firestore
        .collection("gifts")
        .where("qrToken", isEqualTo: qrToken)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return GiftDto.fromJson(snapshot.docs.first.data());
  }
}
