import '../../../../core_import.dart';

abstract class ProfileCheckState extends Equatable {
  const ProfileCheckState();
  @override
  List<Object?> get props => [];
}

class ProfileCheckInitial extends ProfileCheckState {}

class ProfileChecking extends ProfileCheckState {}

class ProfileExists extends ProfileCheckState {}

class ProfileNotFound extends ProfileCheckState {}
