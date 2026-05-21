import '../../../../core_import.dart';

class HostIdleSection extends StatelessWidget {
  const HostIdleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: HostPadding.card(context),
          decoration: HostDecorations.idleCard(context),
          child: Row(
            children: [
              Container(
                width: context.r(mobile: 42),
                height: context.r(mobile: 42),
                decoration: HostDecorations.cardIconBox(context),
                child: Icon(
                  HostIcons.idleWaiting,
                  color: HostColors.cornerIdle,
                  size: context.sp(mobile: 22),
                ),
              ),
              SizedBox(width: context.w(mobile: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waiting to scan...',
                      style: HostTextStyles.cardTitle(
                        context,
                        HostColors.idleText,
                      ),
                    ),
                    SizedBox(height: context.h(mobile: 3)),
                    Text(
                      'Camera is active and ready',
                      style: HostTextStyles.cardSubtitle(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Center(
          child: Text(
            'Hold the QR code steady for faster detection',
            textAlign: TextAlign.center,
            style: HostTextStyles.muted(context),
          ),
        ),
      ],
    );
  }
}
