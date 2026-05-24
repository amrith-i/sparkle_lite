// import '../../../../../core_import.dart';

// // ─── Events ───────────────────────────────────────────────────────────────────

// abstract class HomeEvent extends Equatable {
//   const HomeEvent();

//   @override
//   List<Object?> get props => [];
// }

// class HomeDashboardLoaded extends HomeEvent {
//   final String uid;
//   const HomeDashboardLoaded(this.uid);

//   @override
//   List<Object?> get props => [uid];
// }

// class HomeNavTabChanged extends HomeEvent {
//   final int index;
//   const HomeNavTabChanged(this.index);

//   @override
//   List<Object?> get props => [index];
// }

// // ─── States ───────────────────────────────────────────────────────────────────

// abstract class HomeState extends Equatable {
//   const HomeState();

//   @override
//   List<Object?> get props => [];
// }

// class HomeInitial extends HomeState {}

// class HomeLoading extends HomeState {}

// class HomeLoaded extends HomeState {
//   final HomeDashboardEntity dashboard;
//   final int activeTab;

//   const HomeLoaded({required this.dashboard, this.activeTab = 0});

//   HomeLoaded copyWith({int? activeTab}) =>
//       HomeLoaded(dashboard: dashboard, activeTab: activeTab ?? this.activeTab);

//   @override
//   List<Object?> get props => [dashboard, activeTab];
// }

// class HomeError extends HomeState {
//   final String message;
//   const HomeError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// // ─── BLoC ─────────────────────────────────────────────────────────────────────

// @injectable
// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final GetDashboardUsecase getDashboardUsecase;

//   HomeBloc(this.getDashboardUsecase) : super(HomeInitial()) {
//     on<HomeDashboardLoaded>(_onLoad);
//     on<HomeNavTabChanged>(_onTabChanged);
//   }

//   Future<void> _onLoad(
//     HomeDashboardLoaded event,
//     Emitter<HomeState> emit,
//   ) async {
//     emit(HomeLoading());
//     final result = await getDashboardUsecase(event.uid);
//     if (result.isSuccess) {
//       emit(HomeLoaded(dashboard: result.data!));
//     } else {
//       emit(HomeError(result.failure!.userMessage));
//     }
//   }

//   void _onTabChanged(HomeNavTabChanged event, Emitter<HomeState> emit) {
//     if (state is HomeLoaded) {
//       emit((state as HomeLoaded).copyWith(activeTab: event.index));
//     }
//   }
// }
