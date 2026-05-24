import '../../../../../core_import.dart';

class OnboardingDotIndicator extends StatelessWidget {
  final int total;
  final int current;

  const OnboardingDotIndicator({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? OnboardingColors.dotActive
                : OnboardingColors.dotInactive,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
