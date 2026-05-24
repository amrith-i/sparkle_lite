import '../../../../../core_import.dart';

class OnboardingSlide extends StatelessWidget {
  final OnboardingItemEntity item;

  const OnboardingSlide({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: OnboardingPaddings.page,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: context.w(mobile: 110),
            height: context.w(mobile: 110),
            decoration: OnboardingDecorations.iconContainer(context),
            child: Center(
              child: Text(
                item.emoji,
                style: TextStyle(fontSize: context.sp(mobile: 56)),
              ),
            ),
          ),
          SizedBox(height: context.h(mobile: 40)),
          Text(
            item.title,
            style: OnboardingTextStyles.title(context),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.h(mobile: 16)),
          Text(
            item.subtitle,
            style: OnboardingTextStyles.subtitle(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
