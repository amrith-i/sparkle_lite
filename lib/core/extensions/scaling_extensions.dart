import 'package:flutter/widgets.dart';
import '../responsive/screen_scaler.dart';
import '../responsive/responsive_context.dart';

extension ResponsiveScale on BuildContext {
  double sp({double? mobile, double? tablet, double? desktop}) {
    final value = pick(mobile: mobile, tablet: tablet, desktop: desktop);
    return ScreenScaler.instance.scale(value);
  }

  double w({double? mobile, double? tablet, double? desktop}) {
    final value = pick(mobile: mobile, tablet: tablet, desktop: desktop);
    return ScreenScaler.instance.scaleWidth(value);
  }

  double h({double? mobile, double? tablet, double? desktop}) {
    final value = pick(mobile: mobile, tablet: tablet, desktop: desktop);
    return ScreenScaler.instance.scaleHeight(value);
  }

  double r({double? mobile, double? tablet, double? desktop}) {
    final value = pick(mobile: mobile, tablet: tablet, desktop: desktop);
    return ScreenScaler.instance.scale(value);
  }

  // double wp(double percent) {
  //   return (MediaQuery.of(this).size.width * percent) / 100;
  // }

  // double hp(double percent) {
  //   return (MediaQuery.of(this).size.height * percent) / 100;
  // }
}
