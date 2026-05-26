import '../../../../core_import.dart';

/// Filter tabs shown at the top of the Health Records page.
enum RecordsFilterType {
  all,
  labReport,
  prescription,
  scanReport,
  doctorVisitNote,
  other;

  String get label {
    switch (this) {
      case RecordsFilterType.all:
        return 'All';
      case RecordsFilterType.labReport:
        return 'Lab Report';
      case RecordsFilterType.prescription:
        return 'Prescription';
      case RecordsFilterType.scanReport:
        return 'Scan Report';
      case RecordsFilterType.doctorVisitNote:
        return 'Doctor Visit Note';
      case RecordsFilterType.other:
        return 'Other';
    }
  }

  /// Returns the Firestore recordType value that matches this filter.
  String? get firestoreValue {
    switch (this) {
      case RecordsFilterType.all:
        return null; // no filter — show all
      case RecordsFilterType.labReport:
        return 'Lab Report';
      case RecordsFilterType.prescription:
        return 'Prescription';
      case RecordsFilterType.scanReport:
        return 'Scan Report';
      case RecordsFilterType.doctorVisitNote:
        return 'Doctor Visit Note';
      case RecordsFilterType.other:
        return 'Other';
    }
  }
}

abstract class RecordsState extends Equatable {
  const RecordsState();

  @override
  List<Object?> get props => [];
}

class RecordsInitial extends RecordsState {}

class RecordsLoading extends RecordsState {}

class RecordsLoaded extends RecordsState {
  /// Full unfiltered list from Firestore.
  final List<HealthRecordEntity> allRecords;

  /// Currently displayed list (after filter applied).
  final List<HealthRecordEntity> filteredRecords;

  final RecordsFilterType activeFilter;

  const RecordsLoaded({
    required this.allRecords,
    required this.filteredRecords,
    required this.activeFilter,
  });

  @override
  List<Object?> get props => [allRecords, filteredRecords, activeFilter];
}

class RecordsError extends RecordsState {
  final String message;
  const RecordsError(this.message);

  @override
  List<Object?> get props => [message];
}

class RecordsDeleteSuccess extends RecordsState {}

class RecordsDeleteFailure extends RecordsState {
  final String message;
  const RecordsDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
