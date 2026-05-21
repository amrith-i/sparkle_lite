import '../../../../core_import.dart';

class GuestRedeemedBox extends StatelessWidget {
  const GuestRedeemedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: GuestColors.redeemedBoxBg,
        border: Border.all(color: GuestColors.redeemedBoxBorder, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            GuestIcons.redeemed,
            size: context.sp(mobile: 72),
            color: GuestColors.redeemedIcon,
          ),
          SizedBox(height: context.h(mobile: 12)),
          Text(
            'Gift already redeemed',
            style: GuestTextStyles.redeemedTitle(context),
          ),
          SizedBox(height: context.h(mobile: 6)),
          Text(
            'This QR is permanently invalid',
            style: GuestTextStyles.redeemedSubtitle(context),
          ),
        ],
      ),
    );
  }
}
