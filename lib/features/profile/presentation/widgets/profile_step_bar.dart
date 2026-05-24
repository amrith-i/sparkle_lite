import '../../../../../core_import.dart';

class ProfileStepBar extends StatelessWidget {
  final int current;
  final int total;

  const ProfileStepBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final isActive = i <= current - 1;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: context.h(mobile: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? ProfileColors.stepBarActive
                  : ProfileColors.stepBarInactive,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
