import '../../core_import.dart';

@LazySingleton()
class NetworkListenerService {
  final NetworkChecker _checker;
  final AppRouter _router;

  StreamSubscription<bool>? _sub;
  bool _isShowing = false;

  NetworkListenerService(this._checker, this._router);

  Future<void> startListening() async {
    _sub = _checker.onStatusChange.listen((isOnline) {
      if (!isOnline) {
        _show();
      } else {
        _hide();
      }
    });
  }

  void _show() {
    if (_isShowing) return;
    _isShowing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _router.push(const NoInternetRoute());
    });
  }

  void _hide() {
    if (!_isShowing) return;
    _isShowing = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_router.canPop()) {
        _router.pop();
      }
    });
  }

  void dispose() => _sub?.cancel();
}
