import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService({required void Function(String payload) onTapPayload})
    : _onTapPayload = onTapPayload;

  final void Function(String payload) _onTapPayload;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationDetails(
    'Channel_ID',
    'Main Channel',
    channelDescription: 'Local notifications for Resonate',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const _details = NotificationDetails(android: _androidChannel);

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) _onTapPayload(payload);
      },
    );

    await _quietenPushServiceChannel();
  }

  /// Claims the Appwrite push plugin's foreground-service channel at minimum
  /// importance before the plugin creates it at `IMPORTANCE_LOW`.
  ///
  /// Android requires a foreground service to show a notification and there is
  /// no way to suppress it, but at `Importance.min` it carries no status-bar
  /// icon and collapses to the bottom of the shade instead of sitting at the
  /// top of the list.
  ///
  /// The id must stay in step with `PushBackground.SERVICE_CHANNEL_ID` in the
  /// appwrite package; a mismatch silently creates an unused channel and the
  /// plugin's own stays at LOW.
  ///
  /// Only effective on a fresh install: Android ignores importance changes to
  /// an existing channel, and restores the previous settings if one is deleted
  /// and recreated under the same id. An install that has already run keeps
  /// LOW until the user lowers it themselves.
  Future<void> _quietenPushServiceChannel() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        'appwrite-push-service',
        'Background connection',
        description: 'Keeps notifications arriving while Resonate is closed.',
        importance: Importance.min,
        showBadge: false,
      ),
    );
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: payload,
    );
  }
}
