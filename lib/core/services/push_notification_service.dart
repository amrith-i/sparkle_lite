import '../../core_import.dart';

@LazySingleton()
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      await _initLocalNotifications();
      AppLogger.log('Local notifications initialized ✅');
    } catch (e) {
      AppLogger.log('⚠️ Local notification init failed: $e');
    }

    try {
      await _requestPermission();
      AppLogger.log('FCM permission requested ✅');
    } catch (e) {
      AppLogger.log('⚠️ Permission request failed: $e');
    }

    try {
      if (!kIsWeb) {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            );
      }
    } catch (e) {
      AppLogger.log('⚠️ Foreground presentation setup failed: $e');
    }

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpened);

    try {
      await _handleInitialMessage();
    } catch (e) {
      AppLogger.log('⚠️ Initial message handling failed: $e');
    }

    _listenTokenRefresh();

    try {
      if (!kIsWeb && Platform.isIOS) {
        final apns = await FirebaseMessaging.instance.getAPNSToken().timeout(
          const Duration(seconds: 5),
        );
        AppLogger.log('📲 APNs token: $apns');
      }

      final fcm = await _messaging.getToken().timeout(
        const Duration(seconds: 5),
      );
      AppLogger.log('📩 FCM token: $fcm');
    } catch (e, stack) {
      AppLogger.log('❌ FCM token fetch failed: $e');
      AppLogger.log(stack.toString());
    }
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _local.initialize(
      settings: const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        AppLogger.log('🔔 Notification tapped: ${response.payload}');
      },
    );

    if (!kIsWeb && Platform.isAndroid) {
      await _local
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'default_channel',
              'Notifications',
              description: 'Sparkle Lite notifications',
              importance: Importance.high,
            ),
          );
    }
  }

  Future<String?> getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      AppLogger.log('FCM getToken error: $e');
      return null;
    }
  }

  Future<void> _requestPermission() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
      }
    } else {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    if (!kIsWeb && Platform.isIOS) return;

    _local.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: message.data.toString(),
    );

    AppLogger.log('📩 Foreground message: ${notification.title}');
  }

  void _onNotificationOpened(RemoteMessage message) {
    AppLogger.log('📦 Notification opened from background');
    AppLogger.log('📦 messageId: ${message.messageId}');
    AppLogger.log('📦 data: ${message.data}');
    // TODO: navigate based on message.data
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      AppLogger.log('📦 App opened from terminated via notification');
      AppLogger.log('📦 data: ${message.data}');
      // TODO: navigate based on message.data
    }
  }

  void _listenTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) {
      AppLogger.log('🔄 FCM token refreshed: $newToken');
      // TODO: send new token to Firestore
    });
  }
}
