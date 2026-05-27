import '../../../../core_import.dart';

@injectable
class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final FetchTimelineUsecase _fetchTimelineUsecase;

  TimelineBloc(this._fetchTimelineUsecase) : super(TimelineInitial()) {
    on<LoadTimeline>(_onLoadTimeline);
    on<RefreshTimeline>(_onRefreshTimeline);
    on<FilterTimeline>(_onFilterTimeline);
  }

  Future<void> _onLoadTimeline(
    LoadTimeline event,
    Emitter<TimelineState> emit,
  ) async {
    emit(TimelineLoading());
    final result = await _fetchTimelineUsecase(
      FetchTimelineParams(userId: event.userId),
    );
    if (result.isSuccess) {
      emit(
        TimelineLoaded(
          allItems: result.data!,
          activeFilter: TimelineFilter.all,
        ),
      );
    } else {
      emit(TimelineError(result.failure!.userMessage));
    }
  }

  Future<void> _onRefreshTimeline(
    RefreshTimeline event,
    Emitter<TimelineState> emit,
  ) async {
    final currentFilter = state is TimelineLoaded
        ? (state as TimelineLoaded).activeFilter
        : TimelineFilter.all;

    final result = await _fetchTimelineUsecase(
      FetchTimelineParams(userId: event.userId),
    );
    if (result.isSuccess) {
      emit(TimelineLoaded(allItems: result.data!, activeFilter: currentFilter));
    } else {
      emit(TimelineError(result.failure!.userMessage));
    }
  }

  void _onFilterTimeline(FilterTimeline event, Emitter<TimelineState> emit) {
    if (state is TimelineLoaded) {
      emit((state as TimelineLoaded).copyWith(activeFilter: event.filter));
    }
  }
}
