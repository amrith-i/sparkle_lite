import '../../core_import.dart';

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

    // Firestore offline persistence
    await _initFirestorePersistence();

    // Push notifications
    await getIt<PushNotificationService>().init();
    AppLogger.log('PushNotificationService started ✅');

    // Network listener
    getIt<NetworkListenerService>().startListening();
    AppLogger.log('NetworkListenerService started ✅');

    _initialized = true;
    AppLogger.log('AppBootstrapper complete ✅');
  }

  static Future<void> _initFirestorePersistence() async {
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      AppLogger.log('Firestore offline persistence enabled ✅');
    } catch (e) {
      AppLogger.log('Firestore persistence error: $e');
    }
  }
}
