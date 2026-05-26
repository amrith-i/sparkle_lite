import '../../../../core_import.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchHomeUsecase fetchHomeUsecase;
  final AddSymptomUsecase addSymptomUsecase;
  final UpdateSymptomUsecase updateSymptomUsecase;
  final UploadRecordUsecase uploadRecordUsecase;
  final AddDoctorVisitUsecase addDoctorVisitUsecase;
  final FetchSymptomLogsForInsightUsecase fetchSymptomLogsForInsightUsecase;
  final GenerateAiInsightUsecase generateAiInsightUsecase;
  final SaveInsightToTimelineUsecase saveInsightToTimelineUsecase;

  HomeBloc(
    this.fetchHomeUsecase,
    this.addSymptomUsecase,
    this.updateSymptomUsecase,
    this.uploadRecordUsecase,
    this.addDoctorVisitUsecase,
    this.fetchSymptomLogsForInsightUsecase,
    this.generateAiInsightUsecase,
    this.saveInsightToTimelineUsecase,
  ) : super(HomeInitial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
    on<SubmitSymptom>(_onSubmitSymptom);
    on<SubmitUploadRecord>(_onSubmitUploadRecord);
    on<SubmitDoctorVisit>(_onSubmitDoctorVisit);
    on<FetchSymptomLogsForInsight>(_onFetchSymptomLogs);
    on<GenerateAiInsight>(_onGenerateAiInsight);
    on<SaveInsightToTimeline>(_onSaveInsightToTimeline);
  }

  Future<void> _onLoadHome(LoadHome event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await fetchHomeUsecase(
      FetchHomeParams(userId: event.userId),
    );
    if (result.isSuccess) {
      emit(HomeLoaded(result.data!));
    } else {
      emit(HomeError(result.failure!.userMessage));
    }
  }

  Future<void> _onRefreshHome(
    RefreshHome event,
    Emitter<HomeState> emit,
  ) async {
    final result = await fetchHomeUsecase(
      FetchHomeParams(userId: event.userId),
    );
    if (result.isSuccess) {
      emit(HomeLoaded(result.data!));
    } else {
      emit(HomeError(result.failure!.userMessage));
    }
  }

  Future<void> _onSubmitSymptom(
    SubmitSymptom event,
    Emitter<HomeState> emit,
  ) async {
    emit(SymptomSubmitLoading());

    final ApiResult<void> result;

    if (event.logId != null && event.logId!.isNotEmpty) {
      result = await updateSymptomUsecase(
        UpdateSymptomParams(
          userId: event.userId,
          logId: event.logId!,
          entity: event.entity,
        ),
      );
    } else {
      result = await addSymptomUsecase(
        AddSymptomParams(userId: event.userId, entity: event.entity),
      );
    }

    if (result.isSuccess) {
      emit(SymptomSubmitSuccess());
    } else {
      emit(SymptomSubmitFailure(result.failure!.userMessage));
    }
  }

  Future<void> _onSubmitUploadRecord(
    SubmitUploadRecord event,
    Emitter<HomeState> emit,
  ) async {
    emit(UploadRecordLoading());
    final result = await uploadRecordUsecase(
      UploadRecordParams(userId: event.userId, entity: event.entity),
    );
    if (result.isSuccess) {
      emit(UploadRecordSuccess());
    } else {
      emit(UploadRecordFailure(result.failure!.userMessage));
    }
  }

  Future<void> _onSubmitDoctorVisit(
    SubmitDoctorVisit event,
    Emitter<HomeState> emit,
  ) async {
    emit(DoctorVisitSubmitLoading());
    final result = await addDoctorVisitUsecase(
      AddDoctorVisitParams(userId: event.userId, entity: event.entity),
    );
    if (result.isSuccess) {
      emit(DoctorVisitSubmitSuccess());
    } else {
      emit(DoctorVisitSubmitFailure(result.failure!.userMessage));
    }
  }

  // ── AI Insight handlers ───────────────────────────────────────────────────

  Future<void> _onFetchSymptomLogs(
    FetchSymptomLogsForInsight event,
    Emitter<HomeState> emit,
  ) async {
    emit(SymptomLogsLoading());
    final result = await fetchSymptomLogsForInsightUsecase(
      FetchSymptomLogsForInsightParams(userId: event.userId),
    );
    if (result.isSuccess) {
      emit(SymptomLogsLoaded(result.data!));
    } else {
      emit(SymptomLogsFailure(result.failure!.userMessage));
    }
  }

  Future<void> _onGenerateAiInsight(
    GenerateAiInsight event,
    Emitter<HomeState> emit,
  ) async {
    emit(AiInsightGenerating());
    final result = await generateAiInsightUsecase(
      GenerateAiInsightParams(
        userId: event.userId,
        selectedLogs: event.selectedLogs,
      ),
    );
    if (result.isSuccess) {
      emit(AiInsightGenerated(result.data!));
    } else {
      emit(AiInsightGenerateFailure(result.failure!.userMessage));
    }
  }

  Future<void> _onSaveInsightToTimeline(
    SaveInsightToTimeline event,
    Emitter<HomeState> emit,
  ) async {
    emit(InsightSavingToTimeline());
    final result = await saveInsightToTimelineUsecase(
      SaveInsightParams(userId: event.userId, insight: event.insight),
    );
    if (result.isSuccess) {
      emit(InsightSavedToTimeline());
    } else {
      emit(InsightSaveToTimelineFailure(result.failure!.userMessage));
    }
  }

  void _onResetAiInsightState(
    ResetAiInsightState event,
    Emitter<HomeState> emit,
  ) {
    // If we're currently in generating state, reset to loaded state
    if (state is AiInsightGenerating) {
      // Get the current logs if available
      final currentState = state;
      if (currentState is SymptomLogsLoaded) {
        emit(currentState);
      } else {
        // If no logs loaded, we need to keep the loaded state
        // The actual logs will be refetched when the page rebuilds
      }
    }
  }
}
