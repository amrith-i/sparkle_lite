import '../../../../core_import.dart';

@injectable
class RecordsBloc extends Bloc<RecordsEvent, RecordsState> {
  final FetchHealthRecordsUsecase fetchHealthRecordsUsecase;
  final DeleteHealthRecordUsecase deleteHealthRecordUsecase;

  RecordsBloc(this.fetchHealthRecordsUsecase, this.deleteHealthRecordUsecase)
    : super(RecordsInitial()) {
    on<LoadHealthRecords>(_onLoadHealthRecords);
    on<FilterHealthRecords>(_onFilterHealthRecords);
    on<DeleteHealthRecord>(_onDeleteHealthRecord);
  }

  Future<void> _onLoadHealthRecords(
    LoadHealthRecords event,
    Emitter<RecordsState> emit,
  ) async {
    emit(RecordsLoading());
    final result = await fetchHealthRecordsUsecase(
      FetchHealthRecordsParams(userId: event.userId),
    );
    if (result.isSuccess) {
      final records = result.data!;
      emit(
        RecordsLoaded(
          allRecords: records,
          filteredRecords: records,
          activeFilter: RecordsFilterType.all,
        ),
      );
    } else {
      emit(RecordsError(result.failure!.userMessage));
    }
  }

  void _onFilterHealthRecords(
    FilterHealthRecords event,
    Emitter<RecordsState> emit,
  ) {
    final current = state;
    if (current is! RecordsLoaded) return;

    final filtered = event.filter == RecordsFilterType.all
        ? current.allRecords
        : current.allRecords
              .where(
                (record) => record.recordType == event.filter.firestoreValue,
              )
              .toList();

    emit(
      RecordsLoaded(
        allRecords: current.allRecords,
        filteredRecords: filtered,
        activeFilter: event.filter,
      ),
    );
  }

  Future<void> _onDeleteHealthRecord(
    DeleteHealthRecord event,
    Emitter<RecordsState> emit,
  ) async {
    final current = state;
    if (current is! RecordsLoaded) return;

    final result = await deleteHealthRecordUsecase(
      DeleteHealthRecordParams(userId: event.userId, recordId: event.recordId),
    );

    if (result.isSuccess) {
      // Remove from both lists immediately for instant UI update.
      final updatedAll = current.allRecords
          .where((r) => r.id != event.recordId)
          .toList();
      final updatedFiltered = current.filteredRecords
          .where((r) => r.id != event.recordId)
          .toList();

      emit(RecordsDeleteSuccess());
      emit(
        RecordsLoaded(
          allRecords: updatedAll,
          filteredRecords: updatedFiltered,
          activeFilter: current.activeFilter,
        ),
      );
    } else {
      emit(RecordsDeleteFailure(result.failure!.userMessage));
      // Restore previous state so list isn't corrupted.
      emit(current);
    }
  }
}
