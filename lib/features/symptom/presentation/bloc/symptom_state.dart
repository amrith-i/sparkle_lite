import '../../../../core_import.dart';

/// Filter tabs shown at the top of the Symptom Log page.
enum SymptomFilterType {
  all,
  periodOngoing,
  noPeriod,
  periodStarted,
  periodEnded;

  String get label {
    switch (this) {
      case SymptomFilterType.all:
        return 'All';
      case SymptomFilterType.periodOngoing:
        return 'Period ongoing';
      case SymptomFilterType.noPeriod:
        return 'No period';
      case SymptomFilterType.periodStarted:
        return 'Period started';
      case SymptomFilterType.periodEnded:
        return 'Period ended';
    }
  }

  /// Returns the Firestore periodStatus value that matches this filter.
  String? get firestoreValue {
    switch (this) {
      case SymptomFilterType.all:
        return null; // no filter — show all
      case SymptomFilterType.periodOngoing:
        return 'Period ongoing';
      case SymptomFilterType.noPeriod:
        return 'No period';
      case SymptomFilterType.periodStarted:
        return 'Period started';
      case SymptomFilterType.periodEnded:
        return 'Period ended';
    }
  }
}

abstract class SymptomState extends Equatable {
  const SymptomState();

  @override
  List<Object?> get props => [];
}

class SymptomInitial extends SymptomState {}

class SymptomLoading extends SymptomState {}

class SymptomLoaded extends SymptomState {
  /// Full unfiltered list from Firestore.
  final List<SymptomLogEntity> allLogs;

  /// Currently displayed list (after filter applied).
  final List<SymptomLogEntity> filteredLogs;

  final SymptomFilterType activeFilter;

  const SymptomLoaded({
    required this.allLogs,
    required this.filteredLogs,
    required this.activeFilter,
  });

  @override
  List<Object?> get props => [allLogs, filteredLogs, activeFilter];
}

class SymptomError extends SymptomState {
  final String message;
  const SymptomError(this.message);

  @override
  List<Object?> get props => [message];
}

class SymptomDeleteSuccess extends SymptomState {}

class SymptomDeleteFailure extends SymptomState {
  final String message;
  const SymptomDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
