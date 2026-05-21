import '../../../../core_import.dart';

class GuestScratchCard extends StatelessWidget {
  final String qrToken;
  final String giftId;
  final String userId;

  const GuestScratchCard({
    super.key,
    required this.qrToken,
    required this.giftId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final cardH = context.h(mobile: 320);
    final qrSize = context.r(mobile: 240);

    return SizedBox(
      width: double.infinity,
      height: cardH,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: GuestColors.surface,
            child: Center(
              child: SizedBox(
                width: qrSize,
                height: qrSize,
                child: PrettyQrView.data(data: qrToken),
              ),
            ),
          ),

          Scratcher(
            brushSize: 50,
            threshold: 50,
            color: GuestColors.goldMid1,
            onThreshold: () {
              context.read<GiftBloc>().add(UnlockGiftEvent(giftId, userId));
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: GuestDecorations.goldGradient,
              child: const CustomPaint(painter: GuestStripePainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class GuestScratchCardFace extends StatelessWidget {
  const GuestScratchCardFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: GuestDecorations.goldGradient,
      child: CustomPaint(
        painter: const GuestStripePainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              GuestIcons.scratch,
              size: context.sp(mobile: 52),
              color: Colors.white,
            ),
            SizedBox(height: context.h(mobile: 12)),
            Text(
              'Scratch to reveal',
              style: GuestTextStyles.scratchTitle(context),
            ),
            SizedBox(height: context.h(mobile: 6)),
            Text(
              'Swipe your finger to uncover QR',
              style: GuestTextStyles.scratchSubtitle(context),
            ),
          ],
        ),
      ),
    );
  }
}
