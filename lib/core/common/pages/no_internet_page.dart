import 'package:flutter/material.dart';
import '../../../core_import.dart';

@RoutePage()
class NoInternetPage extends StatefulWidget {
  const NoInternetPage({super.key});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  final _networkChecker = getIt<NetworkChecker>();
  bool _checking = false;

  Future<void> _retryConnection() async {
    setState(() => _checking = true);

    final hasInternet = await _networkChecker.hasConnection();
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (!hasInternet) {
      setState(() => _checking = false);

      AppNotifier.show(
        context,
        'Internet Connection is still unavailable.Please check again.',
        type: MessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppStatusBar(
        style: AppStatusBarStyles.transparentDarkIcons,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(mobile: 30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.noInternet,
                    height: context.w(mobile: 200),
                    width: context.w(mobile: 200),
                  ),
                  SizedBox(height: context.h(mobile: 20)),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: context.sp(mobile: 20),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.h(mobile: 8)),
                  Text(
                    'Something went wrong. Please check your Wi-Fi or mobile data connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: context.sp(mobile: 14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: context.h(mobile: 25)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(mobile: 16),
                    ),
                    child: SizedBox(
                      height: context.h(mobile: 48),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checking ? null : _retryConnection,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          // padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Color(0xFF6054F6),
                          foregroundColor: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.r(mobile: 40),
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: _checking
                            ? AppInlineLoader(size: 50)
                            : Text(
                                'Try again',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
