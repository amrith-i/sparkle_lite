import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Base design dimensions — these are the mobile Figma canvas dimensions.
/// Desktop layouts use fixed values directly and bypass the scaler.
const double _kBaseWidth = 375.0;
const double _kBaseHeight = 812.0;

class ScreenScaler {
  ScreenScaler._();
  static final ScreenScaler instance = ScreenScaler._();

  late Size _deviceSize;
  bool _initialized = false;

  /// On web/desktop we treat the scaler as a no-op (scale factor = 1.0)
  /// so that desktop layouts that use fixed values are unaffected.
  bool get _isDesktopContext =>
      kIsWeb ? _deviceSize.width >= 900 : (_deviceSize.shortestSide >= 900);

  double get _scaleW =>
      _isDesktopContext ? 1.0 : _deviceSize.width / _kBaseWidth;
  double get _scaleH =>
      _isDesktopContext ? 1.0 : _deviceSize.height / _kBaseHeight;

  double get _scaleText {
    if (_isDesktopContext) return 1.0;
    return _scaleW.clamp(0.8, 1.0);
  }

  void init(Size deviceSize) {
    _deviceSize = deviceSize;
    _initialized = true;
  }

  void _ensureInit() {
    assert(
      _initialized,
      'ScreenScaler.init must be called before using scaling methods.',
    );
  }

  double scale(num value) {
    _ensureInit();
    return value * _scaleText;
  }

  double scaleWidth(num value) {
    _ensureInit();
    return value * _scaleW;
  }

  double scaleHeight(num value) {
    _ensureInit();
    return value * _scaleH;
  }

  double get scaleW => _scaleW;
  double get scaleH => _scaleH;
  double get scaleText => _scaleText;
}
