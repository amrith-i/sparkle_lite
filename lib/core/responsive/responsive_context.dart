import 'package:flutter/widgets.dart';

extension ResponsiveContext on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get shortestSide => _size.shortestSide;

  bool get isMobile => shortestSide < 600;
  bool get isTablet => shortestSide >= 600 && shortestSide < 900;
  bool get isDesktop => shortestSide >= 900;

  double get width => _size.width;
  double get height => _size.height;

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

// extension ResponsiveContext on BuildContext {
//   double get width => MediaQuery.of(this).size.width;

//   bool get isMobile  => width < 600;
//   bool get isTablet  => width >= 600 && width < 1024;
//   bool get isDesktop => width >= 1024;

//   double pick({
//     double? mobile,
//     double? tablet,
//     double? desktop,
//   }) {
//     if (isDesktop) return desktop ?? tablet ?? mobile ?? 0;
//     if (isTablet)  return tablet ?? mobile ?? desktop ?? 0;
//     return mobile ?? tablet ?? desktop ?? 0;
//   }
// }
