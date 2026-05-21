import '../../../../core_import.dart';

abstract class HostState extends Equatable {
  const HostState();

  @override
  List<Object?> get props => [];
}

class HostInitial extends HostState {}
