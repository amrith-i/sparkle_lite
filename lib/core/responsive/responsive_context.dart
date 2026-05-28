import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

extension ResponsiveContext on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get width => _size.width;
  double get height => _size.height;

  double get shortestSide => _size.shortestSide;

  double get _breakpoint => kIsWeb ? width : shortestSide;

  bool get isMobile => _breakpoint < 600;
  bool get isTablet => _breakpoint >= 600 && _breakpoint < 900;
  bool get isDesktop => _breakpoint >= 900;

  double pick({double? mobile, double? tablet, double? desktop}) {
    assert(
      mobile != null || tablet != null || desktop != null,
      'pick() requires at least one value',
    );
    if (isDesktop) return desktop ?? tablet ?? mobile!;
    if (isTablet) return tablet ?? mobile!;
    return mobile!;
  }
}
