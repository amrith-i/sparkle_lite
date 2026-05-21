import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core_import.dart';

@RoutePage()
class HostPage extends StatefulWidget {
  const HostPage({super.key});

  @override
  State<HostPage> createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  String? _scannedToken;
  bool _scanned = false;
  bool _wasReset = false;
  MobileScannerController _scannerController = MobileScannerController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _resetScanner() async {
    await _scannerController.dispose();
    setState(() {
      _scannedToken = null;
      _scanned = false;
      _wasReset = true;
      _scannerController = MobileScannerController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GiftBloc>(),
      child: BlocListener<GiftBloc, GiftState>(
        listener: (context, state) {
          if (state is GiftLoaded && state.gift.status == 'redeemed') {
            showHostSuccessDialog(
              context,
              onDone: () {
                Navigator.pop(context);
                _resetScanner();
              },
            );
          }
          if (state is GiftError) {
            showHostErrorDialog(
              context,
              message: state.message,
              onScanAgain: () {
                Navigator.pop(context);
                _resetScanner();
              },
            );
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: HostColors.bg,
          drawer: const HostProfileDrawer(),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HostHeader(
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  onLogout: () => context.router.replace(const UserIdRoute()),
                ),

                Expanded(
                  child: Padding(
                    padding: HostPadding.screenH(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: context.h(mobile: 24)),

                        Center(
                          child: Text(
                            'Scan Guest QR Code',
                            textAlign: TextAlign.center,
                            style: HostTextStyles.heading(context),
                          ),
                        ),
                        SizedBox(height: context.h(mobile: 4)),
                        Center(
                          child: Text(
                            'Point the camera at the guest\'s QR code to validate.',
                            textAlign: TextAlign.center,
                            style: HostTextStyles.subLabel(context),
                          ),
                        ),

                        SizedBox(height: context.h(mobile: 16)),

                        Expanded(
                          flex: 5,
                          child: BlocBuilder<GiftBloc, GiftState>(
                            builder: (context, state) {
                              final isError = !_wasReset && state is GiftError;
                              final cornerColor = isError
                                  ? HostColors.cornerRed
                                  : _scanned
                                  ? HostColors.cornerGreen
                                  : HostColors.cornerIdle;

                              return Container(
                                decoration: HostDecorations.scannerBox(context),
                                child: ClipRRect(
                                  borderRadius: HostDecorations.scannerClip(
                                    context,
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Camera feed or blank placeholder
                                      _scanned
                                          ? Container(color: HostColors.surface)
                                          : MobileScanner(
                                              controller: _scannerController,
                                              onDetect: (capture) {
                                                if (_scanned) return;
                                                final token = capture
                                                    .barcodes
                                                    .first
                                                    .rawValue;
                                                if (token != null) {
                                                  setState(() {
                                                    _scannedToken = token;
                                                    _scanned = true;
                                                    _wasReset = false;
                                                  });
                                                  _scannerController.stop();
                                                }
                                              },
                                            ),

                                      // Corner brackets overlay
                                      HostCornerOverlay(color: cornerColor),

                                      // Status badge
                                      Positioned(
                                        bottom: context.h(mobile: 16),
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: HostScannerBadge(
                                            scanned: _scanned,
                                            isError: isError,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: context.h(mobile: 20)),

                        Expanded(
                          flex: 4,
                          child: BlocBuilder<GiftBloc, GiftState>(
                            builder: (context, state) {
                              if (!_wasReset && state is GiftError) {
                                return HostErrorSection(
                                  message: state.message,
                                  onReset: _resetScanner,
                                );
                              }
                              if (_scanned && _scannedToken != null) {
                                return HostRedeemSection(
                                  token: _scannedToken!,
                                  isLoading: state is GiftLoading,
                                  onRedeem: () {
                                    context.read<GiftBloc>().add(
                                      RedeemGiftEvent(
                                        qrToken: _scannedToken!,
                                        redeemedBy: 'HOST001',
                                      ),
                                    );
                                  },
                                  onReset: _resetScanner,
                                );
                              }
                              return const HostIdleSection();
                            },
                          ),
                        ),

                        SizedBox(height: context.h(mobile: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HostHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onLogout;
  const _HostHeader({required this.onMenuTap, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: HostPadding.header(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: CircleAvatar(
              radius: context.r(mobile: 24),
              backgroundColor: Colors.white24,
              child: Icon(
                HostIcons.profile,
                color: Colors.white,
                size: context.sp(mobile: 22),
              ),
            ),
          ),
          Text('Host Scanner', style: HostTextStyles.appBarTitle(context)),
          CircleAvatar(
            radius: context.r(mobile: 24),
            backgroundColor: Colors.white24,
            child: IconButton(
              onPressed: onLogout,
              icon: Icon(
                HostIcons.logout,
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
