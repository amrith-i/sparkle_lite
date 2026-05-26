import '../../../../core_import.dart';

@injectable
class SymptomBloc extends Bloc<SymptomEvent, SymptomState> {
  final FetchSymptomLogsUsecase fetchSymptomLogsUsecase;
  final DeleteSymptomLogUsecase deleteSymptomLogUsecase;

  SymptomBloc(
    this.fetchSymptomLogsUsecase,
    this.deleteSymptomLogUsecase,
  ) : super(SymptomInitial()) {
    on<LoadSymptomLogs>(_onLoadSymptomLogs);
    on<FilterSymptomLogs>(_onFilterSymptomLogs);
    on<DeleteSymptomLog>(_onDeleteSymptomLog);
  }

  Future<void> _onLoadSymptomLogs(
    LoadSymptomLogs event,
    Emitter<SymptomState> emit,
  ) async {
    emit(SymptomLoading());
    final result = await fetchSymptomLogsUsecase(
      FetchSymptomLogsParams(userId: event.userId),
    );
    if (result.isSuccess) {
      final logs = result.data!;
      emit(SymptomLoaded(
        allLogs: logs,
        filteredLogs: logs,
        activeFilter: SymptomFilterType.all,
      ));
    } else {
      emit(SymptomError(result.failure!.userMessage));
    }
  }

  void _onFilterSymptomLogs(
    FilterSymptomLogs event,
    Emitter<SymptomState> emit,
  ) {
    final current = state;
    if (current is! SymptomLoaded) return;

    final filtered = event.filter == SymptomFilterType.all
        ? current.allLogs
        : current.allLogs
            .where((log) =>
                log.periodStatus == event.filter.firestoreValue)
            .toList();

    emit(SymptomLoaded(
      allLogs: current.allLogs,
      filteredLogs: filtered,
      activeFilter: event.filter,
    ));
  }

  Future<void> _onDeleteSymptomLog(
    DeleteSymptomLog event,
    Emitter<SymptomState> emit,
  ) async {
    final current = state;
    if (current is! SymptomLoaded) return;

    final result = await deleteSymptomLogUsecase(
      DeleteSymptomLogParams(userId: event.userId, logId: event.logId),
    );

    if (result.isSuccess) {
      // Remove from both lists immediately for instant UI update.
      final updatedAll =
          current.allLogs.where((l) => l.id != event.logId).toList();
      final updatedFiltered =
          current.filteredLogs.where((l) => l.id != event.logId).toList();

      emit(SymptomDeleteSuccess());
      emit(SymptomLoaded(
        allLogs: updatedAll,
        filteredLogs: updatedFiltered,
        activeFilter: current.activeFilter,
      ));
    } else {
      emit(SymptomDeleteFailure(result.failure!.userMessage));
      // Restore previous state so list isn't corrupted.
      emit(current);
    }
  }
}
