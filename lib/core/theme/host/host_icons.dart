import 'package:flutter/material.dart';

abstract final class HostIcons {
  // Header
  static const IconData profile = Icons.person_rounded;
  static const IconData logout = Icons.logout_rounded;

  // Scanner badge states
  static const IconData scannerIdle = Icons.crop_free_rounded;
  static const IconData scannerSuccess = Icons.check_circle_outline;
  static const IconData scannerError = Icons.cancel_outlined;

  // Status cards
  static const IconData idleWaiting = Icons.wifi_tethering_rounded;
  static const IconData redeemReady = Icons.check_box_rounded;
  static const IconData alreadyUsed = Icons.cancel_rounded;

  // Dialogs
  static const IconData dialogSuccess = Icons.check_circle_rounded;
  static const IconData dialogError = Icons.cancel_rounded;

  // Drawer
  static const IconData drawerRole = Icons.badge_outlined;
  static const IconData drawerScannerId = Icons.qr_code_scanner_rounded;
  static const IconData drawerStatus = Icons.verified_user_outlined;
  static const IconData drawerLogout = Icons.logout_rounded;
}
