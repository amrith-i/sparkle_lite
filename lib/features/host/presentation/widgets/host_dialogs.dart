import '../../../../core_import.dart';

void showHostSuccessDialog(
  BuildContext context, {
  required VoidCallback onDone,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _HostDialog(
      iconBg: HostColors.greenBg,
      icon: HostIcons.dialogSuccess,
      iconColor: HostColors.greenBorder,
      title: 'Gift Redeemed!',
      body: 'This gift has been successfully redeemed.',
      buttonLabel: 'Done',
      buttonColor: HostColors.greenBorder,
      onPressed: onDone,
    ),
  );
}

void showHostErrorDialog(
  BuildContext context, {
  required String message,
  required VoidCallback onScanAgain,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _HostDialog(
      iconBg: HostColors.redBg,
      icon: HostIcons.dialogError,
      iconColor: HostColors.cornerRed,
      title: 'Already Redeemed!',
      body: message,
      buttonLabel: 'Scan Again',
      buttonColor: HostColors.cornerRed,
      onPressed: onScanAgain,
    ),
  );
}

class _HostDialog extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String buttonLabel;
  final Color buttonColor;
  final VoidCallback onPressed;

  const _HostDialog({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(mobile: 24)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.r(mobile: 72),
            height: context.r(mobile: 72),
            decoration: HostDecorations.dialogIconCircle(iconBg),
            child: Icon(icon, color: iconColor, size: context.sp(mobile: 44)),
          ),
          SizedBox(height: context.h(mobile: 16)),

          Text(title, style: HostTextStyles.dialogTitle(context)),
          SizedBox(height: context.h(mobile: 8)),

          Text(
            body,
            textAlign: TextAlign.center,
            style: HostTextStyles.dialogBody(context),
          ),
          SizedBox(height: context.h(mobile: 24)),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: HostDecorations.dialogButtonShape(context),
                padding: EdgeInsets.symmetric(vertical: context.h(mobile: 14)),
                elevation: 0,
              ),
              child: Text(
                buttonLabel,
                style: HostTextStyles.buttonLabel(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
