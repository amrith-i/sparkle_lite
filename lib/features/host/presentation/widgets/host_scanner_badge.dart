import '../../../../core_import.dart';

class HostScannerBadge extends StatelessWidget {
  final bool scanned;
  final bool isError;
  const HostScannerBadge({
    super.key,
    required this.scanned,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color textColor;
    final IconData icon;
    final String label;

    if (isError) {
      bg = HostColors.redBg;
      textColor = HostColors.redText;
      icon = HostIcons.scannerError;
      label = 'Already redeemed';
    } else if (scanned) {
      bg = HostColors.greenBg;
      textColor = HostColors.greenText;
      icon = HostIcons.scannerSuccess;
      label = 'QR detected ✓';
    } else {
      bg = Colors.white.withOpacity(0.88);
      textColor = HostColors.textMuted;
      icon = HostIcons.scannerIdle;
      label = 'Align QR code within the frame';
    }

    return Container(
      padding: HostPadding.badge(context),
      decoration: HostDecorations.badge(context, bg),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: context.sp(mobile: 16)),
          SizedBox(width: context.w(mobile: 6)),
          Text(label, style: HostTextStyles.badgeLabel(context, textColor)),
        ],
      ),
    );
  }
}
