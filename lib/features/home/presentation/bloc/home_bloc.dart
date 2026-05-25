import '../../../../core_import.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchHomeUsecase fetchHomeUsecase;
  final AddSymptomUsecase addSymptomUsecase;
  final UploadRecordUsecase uploadRecordUsecase;

  HomeBloc(
    this.fetchHomeUsecase,
    this.addSymptomUsecase,
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
    final result = await addSymptomUsecase(
      AddSymptomParams(userId: event.userId, entity: event.entity),
    );
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
