import '../../../core_import.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class LoadSession extends SessionEvent {}

class ClearSession extends SessionEvent {}
