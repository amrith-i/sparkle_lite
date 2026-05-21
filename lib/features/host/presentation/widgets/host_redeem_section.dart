import '../../../../core_import.dart';

class HostRedeemSection extends StatelessWidget {
  final String token;
  final bool isLoading;
  final VoidCallback onRedeem;
  final Future<void> Function() onReset;

  const HostRedeemSection({
    super.key,
    required this.token,
    required this.isLoading,
    required this.onRedeem,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: HostPadding.card(context),
          decoration: HostDecorations.greenCard(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.r(mobile: 42),
                height: context.r(mobile: 42),
                decoration: HostDecorations.cardIconBox(context),
                child: Icon(
                  HostIcons.redeemReady,
                  color: HostColors.greenBorder,
                  size: context.sp(mobile: 22),
                ),
              ),
              SizedBox(width: context.w(mobile: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Valid QR — Ready to redeem',
                      style: HostTextStyles.cardTitle(
                        context,
                        HostColors.greenText,
                      ),
                    ),
                    SizedBox(height: context.h(mobile: 3)),
                    Text(
                      'Token: $token',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: HostTextStyles.cardSubtitle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        SizedBox(
          height: context.h(mobile: 56),
          child: ElevatedButton(
            onPressed: isLoading ? null : onRedeem,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              disabledBackgroundColor: HostColors.border,
              shape: HostDecorations.buttonShape(context),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    width: context.r(mobile: 22),
                    height: context.r(mobile: 22),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Redeem Gift',
                    style: HostTextStyles.buttonLabel(context),
                  ),
          ),
        ),

        SizedBox(height: context.h(mobile: 10)),

        Center(
          child: TextButton(
            onPressed: onReset,
            child: Text(
              'Scan a different QR',
              style: HostTextStyles.buttonLabelAlt(context),
            ),
          ),
        ),

        SizedBox(height: context.h(mobile: 4)),

        Center(
          child: Text(
            'Tap to mark this gift as redeemed',
            style: HostTextStyles.muted(context),
          ),
        ),
      ],
    );
  }
}
