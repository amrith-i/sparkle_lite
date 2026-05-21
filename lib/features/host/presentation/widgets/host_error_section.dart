import '../../../../core_import.dart';

class HostErrorSection extends StatelessWidget {
  final String message;
  final Future<void> Function() onReset;

  const HostErrorSection({
    super.key,
    required this.message,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: HostPadding.card(context),
          decoration: HostDecorations.redCard(context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.r(mobile: 42),
                height: context.r(mobile: 42),
                decoration: HostDecorations.cardIconBox(context),
                child: Icon(
                  HostIcons.alreadyUsed,
                  color: HostColors.cornerRed,
                  size: context.sp(mobile: 22),
                ),
              ),
              SizedBox(width: context.w(mobile: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This gift has already been redeemed.',
                      style: HostTextStyles.cardTitle(
                        context,
                        HostColors.redText,
                      ),
                    ),
                    SizedBox(height: context.h(mobile: 3)),
                    Text(message, style: HostTextStyles.cardSubtitle(context)),
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
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: HostColors.cornerRed,
              shape: HostDecorations.buttonShape(context),
              elevation: 0,
            ),
            child: Text(
              'Scan Again',
              style: HostTextStyles.buttonLabel(context),
            ),
          ),
        ),

        SizedBox(height: context.h(mobile: 10)),

        Center(
          child: Text(
            'This QR is permanently invalid',
            style: HostTextStyles.muted(context),
          ),
        ),
      ],
    );
  }
}
