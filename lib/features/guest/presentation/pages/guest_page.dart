import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core_import.dart';

@RoutePage()
class GuestPage extends StatefulWidget {
  final String userId;
  const GuestPage({super.key, required this.userId});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final GlobalKey _qrKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _shareQrImage(String qrToken) async {
    try {
      final boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/gift_qr.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Here is my Gift QR Code! Scan this to redeem the gift.',
        subject: 'Gift QR Code',
      );
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GiftBloc>()..add(GetGiftEvent(widget.userId)),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: GuestColors.bg,

        drawer: GuestProfileDrawer(userId: widget.userId),

        body: SafeArea(
          child: BlocBuilder<GiftBloc, GiftState>(
            builder: (context, state) {
              if (state is GiftLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GiftError) {
                return Center(child: Text(state.message));
              }

              if (state is GiftLoaded) {
                final gift = state.gift;

                return Column(
                  children: [
                    _GuestHeader(
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                      onLogout: () =>
                          context.router.replace(const UserIdRoute()),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: context.h(mobile: 24)),

                            Text(
                              '🎉 ${gift.eventName}',
                              style: GuestTextStyles.eventName(context),
                            ),

                            SizedBox(height: context.h(mobile: 8)),

                            GuestStatusPill(status: gift.status),

                            SizedBox(height: context.h(mobile: 32)),

                            Padding(
                              padding: GuestPadding.screenH(context),
                              child: ClipRRect(
                                borderRadius: GuestDecorations.cardRadius(
                                  context,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: context.h(mobile: 320),
                                  child: _buildCardContent(context, gift),
                                ),
                              ),
                            ),

                            SizedBox(height: context.h(mobile: 28)),

                            // Status text below card
                            GuestStatusTextSection(status: gift.status),

                            SizedBox(height: context.h(mobile: 32)),

                            if (gift.status == 'unlocked')
                              GuestShareButton(
                                onTap: () => _shareQrImage(gift.qrToken),
                              ),

                            SizedBox(height: context.h(mobile: 30)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, gift) {
    switch (gift.status) {
      case 'locked':
        return GuestScratchCard(
          qrToken: gift.qrToken,
          giftId: gift.giftId,
          userId: widget.userId,
        );

      case 'unlocked':
        return RepaintBoundary(
          key: _qrKey,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: GuestColors.surface,
            child: Center(
              child: SizedBox(
                width: context.r(mobile: 240),
                height: context.r(mobile: 240),
                child: PrettyQrView.data(data: gift.qrToken),
              ),
            ),
          ),
        );

      default: // redeemed
        return const GuestRedeemedBox();
    }
  }
}

class _GuestHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onLogout;
  const _GuestHeader({required this.onMenuTap, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blue,
      padding: GuestPadding.header(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              width: context.r(mobile: 44),
              height: context.r(mobile: 44),
              decoration: GuestDecorations.headerIconCircle(),
              child: Icon(
                GuestIcons.profile,
                color: Colors.white,
                size: context.sp(mobile: 24),
              ),
            ),
          ),

          Text('Guest Gift', style: GuestTextStyles.appBarTitle(context)),

          Container(
            width: context.r(mobile: 44),
            height: context.r(mobile: 44),
            decoration: GuestDecorations.headerIconCircle(),
            child: IconButton(
              onPressed: onLogout,
              icon: Icon(
                GuestIcons.logout,
                color: Colors.white,
                size: context.sp(mobile: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
