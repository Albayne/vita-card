import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Wraps FCM (server-pushed updates only — no background polling) and
/// flutter_local_notifications (scheduled on-device reminders).
///
/// Notification text is constrained at the call site, never here: no
/// reminder may name a condition, test type, or the words "counselling",
/// "mental health", "substance", or "recovery".
class NotificationService {
  NotificationService._();

  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _local.initialize(initSettings);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<String?> getFcmToken() => FirebaseMessaging.instance.getToken();

  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) {
    return _local.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'vitacard_reminders',
          'VitaCard Reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }

  static Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) {
    return _local.zonedSchedule(
      id,
      title,
      body,
      _toTz(scheduledDate),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'vitacard_reminders',
          'VitaCard Reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancel(int id) => _local.cancel(id);

  // flutter_local_notifications' zonedSchedule expects a TZDateTime; main()
  // must call tz.initializeTimeZones() before this is used.
  static tz.TZDateTime _toTz(DateTime dateTime) =>
      tz.TZDateTime.from(dateTime, tz.local);
}
