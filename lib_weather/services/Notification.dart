// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/browser.dart' as tz;
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static Future<void> init() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const settings = InitializationSettings(android: android);
//     await _notificationsPlugin.initialize(settings);
//
//     tz.initializeTimeZone();
//   }
//
//   static Future<void> showAlert(String title, String body) async {
//     const androidDetails = AndroidNotificationDetails(
//       'weather_channel',
//       'weather Alerts',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const details = NotificationDetails(android: androidDetails);
//
//     await _notificationsPlugin.show(0, title, body, details);
//   }
// }
