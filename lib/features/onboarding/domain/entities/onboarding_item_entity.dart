import '../../../../../core_import.dart';

class OnboardingItemEntity extends Equatable {
  final String emoji;
  final String title;
  final String subtitle;

  const OnboardingItemEntity({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  List<Object?> get props => [emoji, title, subtitle];
}
