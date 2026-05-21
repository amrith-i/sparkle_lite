import '../../../../core_import.dart';

class GuestShareButton extends StatelessWidget {
  final VoidCallback onTap;
  const GuestShareButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: GuestPadding.screenH(context),
      child: SizedBox(
        width: double.infinity,
        height: context.h(mobile: 52),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(
            GuestIcons.share,
            color: Colors.white,
            size: context.sp(mobile: 20),
          ),
          label: Text('Share', style: GuestTextStyles.shareButton(context)),
          style: ElevatedButton.styleFrom(
            backgroundColor: GuestColors.btnColor,
            shape: GuestDecorations.shareButtonShape(context),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
