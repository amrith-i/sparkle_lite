import '../../../../core_import.dart';

abstract class GiftState {}

class GiftInitial extends GiftState {}

class GiftLoading extends GiftState {}

class GiftLoaded extends GiftState {
  final GiftEntity gift;
  GiftLoaded(this.gift);
}

class GiftRedeemed extends GiftState {
  final String message;
  GiftRedeemed(this.message);
}

class GiftError extends GiftState {
  final String message;
  GiftError(this.message);
}
