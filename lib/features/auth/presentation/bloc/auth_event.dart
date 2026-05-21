abstract class UserEvent {}

class CheckUserEvent extends UserEvent {
  final String userId;

  CheckUserEvent(this.userId);
}
