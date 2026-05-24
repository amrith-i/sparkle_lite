import '../../../core_import.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  final UserSessionModel session;

  const SessionAuthenticated(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionUnauthenticated extends SessionState {}
