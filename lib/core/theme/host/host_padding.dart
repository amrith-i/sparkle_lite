import 'package:flutter/material.dart';

import '../../../core_import.dart';

abstract final class HostPadding {
  static EdgeInsets screenH(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: context.w(mobile: 20));

  static EdgeInsets header(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 20),
    vertical: context.h(mobile: 20),
  );

  static EdgeInsets card(BuildContext context) =>
      EdgeInsets.all(context.r(mobile: 18));

  static EdgeInsets button(BuildContext context) =>
      EdgeInsets.symmetric(vertical: context.h(mobile: 14));

  static EdgeInsets drawerHeader(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 24),
    vertical: context.h(mobile: 32),
  );

  static EdgeInsets drawerItem(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 20),
    vertical: context.h(mobile: 10),
  );

  static EdgeInsets badge(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.w(mobile: 14),
    vertical: context.h(mobile: 7),
  );
}
