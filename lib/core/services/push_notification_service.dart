import 'package:daily_finance_manager/core_import.dart';

@LazySingleton()
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  // Future<void> init() async {
  //   await _initLocalNotifications();

  //   await _requestPermission();

  //   await FirebaseMessaging.instance
  //       .setForegroundNotificationPresentationOptions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );

  //   // _showInitNotification();

  //   FirebaseMessaging.onMessage.listen(_onForegroundMessage);

  //   FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpened);

  //   await _handleInitialMessage();

  //   _listenTokenRefresh();

  //   final apns = await FirebaseMessaging.instance.getAPNSToken();
  //   final fcm = await _messaging.getToken();
  //   AppLogger.log('📲 APNs token: $apns');
  //   AppLogger.log('📩 FCM token: $fcm');
  // }

  Future<void> init() async {
    try {
      await _initLocalNotifications();
    } catch (e) {
      AppLogger.log('⚠️ Local notification init failed: $e');
    }

    try {
      await _requestPermission();
    } catch (e) {
      AppLogger.log('⚠️ Permission request failed: $e');
    }

    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      AppLogger.log('⚠️ Foreground presentation setup failed: $e');
    }

    // Listeners (these are safe)
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpened);

    try {
      await _handleInitialMessage();
    } catch (e) {
      AppLogger.log('⚠️ Initial message handling failed: $e');
    }

    // _listenTokenRefresh();

    try {
      final apns = await FirebaseMessaging.instance.getAPNSToken().timeout(
        const Duration(seconds: 5),
      );

      final fcm = await _messaging.getToken().timeout(
        const Duration(seconds: 5),
      );

      AppLogger.log('📲 APNs token: $apns');
      AppLogger.log('📩 FCM token: $fcm');
    } catch (e, stack) {
      AppLogger.log('❌ FCM token fetch failed: $e');
      AppLogger.log(stack.toString());

      // DO NOT rethrow
      // DO NOT crash
    }
  }

  Future<void> _showInitNotification() async {
    AppLogger.log('🔔 Showing INIT local notification');

    // await _local.show(
    //   999,
    //   'Init Notification',
    //   'Notifications are working on this iPhone',
    //   const NotificationDetails(
    //     iOS: DarwinNotificationDetails(
    //       presentAlert: true,
    //       presentSound: true,
    //       presentBadge: true,
    //     ),
    //     android: AndroidNotificationDetails(
    //       'init_channel',
    //       'Init',
    //       importance: Importance.high,
    //       priority: Priority.high,
    //     ),
    //   ),
    // );
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    // await _local.initialize(
    //   const InitializationSettings(android: android, iOS: ios),
    //   onDidReceiveNotificationResponse: (response) {},
    // );
  }

  Future<String?> getFcmToken() async {
    try {
      final token = await _messaging.getToken();
      return token;
    } catch (e) {
      AppLogger.log('FCM getToken error: $e');
      return null;
    }
  }

  Future<void> _requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
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
      await _messaging.requestPermission();
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (Platform.isIOS) {
      return;
    }

    final notification = message.notification;
    if (notification == null) return;

    // _local.show(
    //   notification.hashCode,
    //   notification.title,
    //   notification.body,
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       'default_channel',
    //       'Notifications',
    //       importance: Importance.high,
    //       priority: Priority.high,
    //     ),
    //   ),
    //   payload: message.data.toString(),
    // );
  }

  void _onNotificationOpened(RemoteMessage message) {
    AppLogger.log('📦 Notification opened from background');
    AppLogger.log('📦 messageId: ${message.messageId}');
    AppLogger.log('📦 data: ${message.data}');
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {}
  }
}
