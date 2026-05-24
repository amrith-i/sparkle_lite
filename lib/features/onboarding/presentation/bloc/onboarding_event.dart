import '../../../../../core_import.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

class OnboardingSkipPressed extends OnboardingEvent {
  const OnboardingSkipPressed();
}

class OnboardingPageChanged extends OnboardingEvent {
  final int index;
  const OnboardingPageChanged(this.index);

  @override
  List<Object?> get props => [index];
}
