import '../../../../core_import.dart';

@injectable
class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final GetGiftUsecase getGiftUsecase;
  final UnlockGiftUsecase unlockGiftUsecase;
  final RedeemGiftUsecase redeemGiftUsecase;
  final GetGiftByTokenUsecase getGiftByTokenUsecase;

  GiftBloc(
    this.getGiftUsecase,
    this.unlockGiftUsecase,
    this.redeemGiftUsecase,
    this.getGiftByTokenUsecase,
  ) : super(GiftInitial()) {
    on<GetGiftEvent>(_getGift);
    on<UnlockGiftEvent>(_unlockGift);
    on<RedeemGiftEvent>(_redeemGift);
    on<CheckGiftStatusEvent>(_checkGiftStatus);
  }

  //--------------------------------
  // GET GIFT
  //--------------------------------
  Future<void> _getGift(GetGiftEvent event, Emitter<GiftState> emit) async {
    emit(GiftLoading());
    try {
      final result = await getGiftUsecase(event.userId);
      if (result != null) {
        emit(GiftLoaded(result));
      } else {
        emit(GiftError("Gift not found"));
      }
    } catch (e) {
      emit(GiftError(e.toString()));
    }
  }

  //--------------------------------
  // UNLOCK GIFT
  //--------------------------------
  // gift_bloc.dart — fix _unlockGift to refresh after unlock
  Future<void> _unlockGift(
    UnlockGiftEvent event,
    Emitter<GiftState> emit,
  ) async {
    try {
      // Unlock on Firestore
      await unlockGiftUsecase(event.giftId);

      // Refresh gift so UI gets updated status automatically
      final result = await getGiftUsecase(event.userId);
      if (result != null) {
        emit(GiftLoaded(result));
      }
    } catch (e) {
      emit(GiftError(e.toString()));
    }
  }

  //--------------------------------
  // REDEEM GIFT
  //--------------------------------
  Future<void> _redeemGift(
    RedeemGiftEvent event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final result = await redeemGiftUsecase(
        RedeemGiftParams(qrToken: event.qrToken, redeemedBy: event.redeemedBy),
      );
      if (result != null) {
        emit(GiftLoaded(result));
      } else {
        emit(GiftError("This gift has already been redeemed."));
      }
    } catch (e) {
      emit(GiftError(e.toString()));
    }
  }

  //--------------------------------
  // CHECK GIFT STATUS BY TOKEN
  //--------------------------------
  Future<void> _checkGiftStatus(
    CheckGiftStatusEvent event,
    Emitter<GiftState> emit,
  ) async {
    emit(GiftLoading());
    try {
      final result = await getGiftByTokenUsecase(event.qrToken);
      if (result != null) {
        emit(GiftLoaded(result));
      } else {
        emit(GiftError("Gift not found"));
      }
    } catch (e) {
      emit(GiftError(e.toString()));
    }
  }
}
