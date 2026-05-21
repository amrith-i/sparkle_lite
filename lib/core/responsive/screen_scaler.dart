
import '../../core_import.dart';

class ScreenScaler {
  ScreenScaler._();
  static final ScreenScaler instance = ScreenScaler._();

  late Size _deviceSize;
  bool _initialized = false;

  double get _scaleW => _deviceSize.width / 375;
  double get _scaleH => _deviceSize.height / 812;

  double get _scaleText {
    final scale = _scaleW;
    return scale.clamp(0.8, 1.0);
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
