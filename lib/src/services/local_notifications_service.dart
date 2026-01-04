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
}
