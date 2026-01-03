// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // Initialization  setting for android
    const androidInitializationSettings = AndroidInitializationSettings(
      "@drawable/logo",
    );

    // Initialization for Ios
    const iosInitializationSettings = DarwinInitializationSettings();

    // Initialization for all
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iosInitializationSettings,
        );

    _notificationsPlugin.initialize(initializationSettings);
  }

  // static void scheduleNotification(TaskModel taskModel) async {
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     '2026',
  //     'tachkil_channle',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //   var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );
  //   await _notificationsPlugin.zonedSchedule(
  //     taskModel.taskId,
  //     taskModel.title,
  //     'Commence dans 1 heure',
  //     tz.TZDateTime.now(tz.).add(const Duration(seconds: 10)),
  //     platformChannelSpecifics,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //   );
  // }
}
