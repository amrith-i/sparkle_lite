import '../../../../core_import.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserExists extends UserState {
  final UserEntity user;

  UserExists(this.user);
}

class UserNotFound extends UserState {
  final String message;

  UserNotFound(this.message);
}
