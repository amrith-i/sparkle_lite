import '../../../../../core_import.dart';

class SplashDots extends StatelessWidget {
  const SplashDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == 0 ? 10 : 8,
          height: i == 0 ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == 0
                ? AuthColors.buttonGradientEnd
                : AuthColors.fieldBorder.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}
