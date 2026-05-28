import '../../../../core_import.dart';

abstract class ProfileCheckEvent extends Equatable {
  const ProfileCheckEvent();
  @override
  List<Object?> get props => [];
}

class CheckProfile extends ProfileCheckEvent {}
