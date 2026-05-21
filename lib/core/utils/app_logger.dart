import '../../core_import.dart';

class AppLogger {
  static bool _enabled = false;

  static void init(bool enableLogs) {
    _enabled = enableLogs;
  }

  static void log(String message) {
    if (_enabled) {
      debugPrint(message);
    }
  }
}
