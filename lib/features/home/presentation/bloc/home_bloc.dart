import '../../../../core_import.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchHomeUsecase fetchHomeUsecase;
  final AddSymptomUsecase addSymptomUsecase;
  final UpdateSymptomUsecase updateSymptomUsecase;
  final UploadRecordUsecase uploadRecordUsecase;

  HomeBloc(
    this.fetchHomeUsecase,
    this.addSymptomUsecase,
    this.updateSymptomUsecase,
    this.uploadRecordUsecase,
  ) : super(HomeInitial()) {
    on<LoadHome>(_onLoadHome);
    on<RefreshHome>(_onRefreshHome);
    on<SubmitSymptom>(_onSubmitSymptom);
    on<SubmitUploadRecord>(_onSubmitUploadRecord);
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
      // Edit mode — update the existing Firestore document at the same UID.
      result = await updateSymptomUsecase(
        UpdateSymptomParams(
          userId: event.userId,
          logId: event.logId!,
          entity: event.entity,
        ),
      );
    } else {
      // Add mode — create a brand-new Firestore document.
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
}
