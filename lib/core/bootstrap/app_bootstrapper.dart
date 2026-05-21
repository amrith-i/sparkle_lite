import 'package:daily_finance_manager/core_import.dart';

class AppBootstrapper {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    final config = getIt<AppConfig>();

    AppLogger.init(config.enableLogs);

    AppLogger.log('========== APP ENVIRONMENT ==========');
    AppLogger.log('ENV        : ${EnvResolver.current.name}');
    AppLogger.log('BASE URL   : ${config.baseUrl}');
    AppLogger.log('SOCKET URL : ${config.socketUrl}');
    AppLogger.log('LOGS       : ${config.enableLogs}');
    AppLogger.log('CRASHLYTICS: ${config.enableCrashlytics}');
    AppLogger.log('=====================================');

    // if (!kIsWeb) {
    //   await Firebase.initializeApp();
    //   AppLogger.log('Firebase initialized ✅');

    //   // Push notifications
    //   getIt<PushNotificationService>().init();
    //   AppLogger.log('PushNotificationService started ✅');
    // }

    getIt<NetworkListenerService>().startListening();
    AppLogger.log('NetworkListenerService started ✅');

    _initialized = true;
    AppLogger.log('AppBootstrapper complete ✅');
  }
}
