import 'package:flutter/material.dart';
import '../../../core_import.dart';

class EnvBanner extends StatelessWidget {
  final Widget child;

  const EnvBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final env = EnvResolver.current;

    if (env == AppEnvironment.prod) {
      return child;
    }

    return Banner(
      message: env.name.toUpperCase(),
      location: BannerLocation.topStart,
      color: Colors.red,
      textStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: context.sp(mobile: 6),
      ),
      child: child,
    );
  }
}
