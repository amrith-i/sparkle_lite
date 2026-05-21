import '../../../../core_import.dart';

class GuestStatusTextSection extends StatelessWidget {
  final String status;
  const GuestStatusTextSection({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final String heading;
    final String subtitle;
    final Color headingColor;

    switch (status) {
      case 'locked':
        heading = 'A special gift awaits you!';
        subtitle = 'Scratch the card above to unlock your QR code';
        headingColor = GuestColors.textPrimary;
      case 'unlocked':
        heading = 'Your gift is ready to share!';
        subtitle = 'Share the QR code with family to redeem';
        headingColor = GuestColors.textPrimary;
      default: // redeemed
        heading = 'Gift already redeemed';
        subtitle = 'This QR is now invalid for all shared users.';
        headingColor = GuestColors.redeemedText;
    }

    return Column(
      children: [
        Text(
          heading,
          style: GuestTextStyles.sectionHeading(context, color: headingColor),
        ),
        SizedBox(height: context.h(mobile: 8)),
        Padding(
          padding: GuestPadding.sectionSubtitle(context),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GuestTextStyles.sectionSubtitle(context),
          ),
        ),
      ],
    );
  }
}
