import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppStatusBarStyles {
  const AppStatusBarStyles._();

  static const transparentDarkIcons = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  static const transparentLightIcons = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );
}
