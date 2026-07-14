import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService({required void Function(String payload) onTapPayload})
      : _onTapPayload = onTapPayload;

  final void Function(String payload) _onTapPayload;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _androidChannel = AndroidNotificationDetails(
    'resonate_default_channel',
    'Resonate Notifications',
    channelDescription: 'General notifications from Resonate',
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
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) _onTapPayload(payload);
      },
    );
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _plugin.show(0, title, body, _details, payload: payload);
  }
}
