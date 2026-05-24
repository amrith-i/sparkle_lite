
import '../../core_import.dart';

@LazySingleton()
class NetworkChecker {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool? _lastStatus;
  bool _initialized = false;

  // 🔒 ignore early emissions
  final DateTime _startTime = DateTime.now();
  static const _startupGrace = Duration(seconds: 2);

  NetworkChecker() {
    _init();
  }

  Stream<bool> get onStatusChange => _controller.stream;

  Future<void> _init() async {
    // 1️⃣ Real initial check
    final initial = await hasConnection();
    _lastStatus = initial;
    _initialized = true;

    _controller.add(initial);

    // 2️⃣ Listen AFTER init
    _connectivity.onConnectivityChanged.listen(_onChange);
  }

  void _onChange(List<ConnectivityResult> results) {
    if (!_initialized) return;

    final isOnline = _hasNetwork(results);

    // 🚨 Ignore early fake OFFLINE
    final isStartupPhase =
        DateTime.now().difference(_startTime) < _startupGrace;

    if (isStartupPhase && !isOnline) {
      AppLogger.log('⏳ Ignored startup offline');
      return;
    }

    if (_lastStatus == isOnline) return;
    _lastStatus = isOnline;

    _controller.add(isOnline);
    AppLogger.log('📶 Network → ${isOnline ? "Online" : "Offline"}');
  }

  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return _hasNetwork(results);
  }

  bool _hasNetwork(List<ConnectivityResult> results) {
    return results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet,
    );
  }

  void dispose() => _controller.close();
}
