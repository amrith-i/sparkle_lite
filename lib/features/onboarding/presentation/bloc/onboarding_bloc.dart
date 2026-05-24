import '../../../../../core_import.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboardingUsecase completeOnboardingUsecase;
  static const int _totalPages = 4;

  OnboardingBloc(this.completeOnboardingUsecase)
    : super(
        const OnboardingInProgress(currentIndex: 0, totalPages: _totalPages),
      ) {
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
    on<OnboardingPageChanged>(_onPageChanged);
  }

  Future<void> _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state as OnboardingInProgress;
    if (current.isLastPage) {
      await completeOnboardingUsecase();
      emit(OnboardingComplete());
    } else {
      emit(
        OnboardingInProgress(
          currentIndex: current.currentIndex + 1,
          totalPages: _totalPages,
        ),
      );
    }
  }

  Future<void> _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    await completeOnboardingUsecase();
    emit(OnboardingComplete());
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      OnboardingInProgress(currentIndex: event.index, totalPages: _totalPages),
    );
  }
}
