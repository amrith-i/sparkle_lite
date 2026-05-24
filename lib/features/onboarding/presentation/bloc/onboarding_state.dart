import '../../../../../core_import.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInProgress extends OnboardingState {
  final int currentIndex;
  final int totalPages;

  const OnboardingInProgress({
    required this.currentIndex,
    required this.totalPages,
  });

  bool get isLastPage => currentIndex == totalPages - 1;

  @override
  List<Object?> get props => [currentIndex, totalPages];
}

class OnboardingComplete extends OnboardingState {}
