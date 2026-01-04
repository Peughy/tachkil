import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/pages/welcome_page.dart';
import 'package:tachkil/src/services/local_notifications_service.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // get the connected statut stock with the sharedPreference
  Future<bool> getIfConnected() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isConnected = preferences.getBool("isConnected") ?? false;
    return isConnected;
  }

  // get theme mode stock with the sharedPreference
  Future<bool> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isDarkTheme = preferences.getBool("isDarkTheme") ?? false;
    return isDarkTheme;
  }

  @override
  void initState() {
    super.initState();
    LocalNotificationsService.initialize();
  }

  // when the user want to clove the app we verified if reminder is active
  // if reminder is active -> do nothing
  // else if reminder isn't active -> delete the id user ansd log information
  @override
  void dispose() async {
    super.dispose();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool activeReminder = preferences.getBool("isReminder") ?? false;

    if (activeReminder == false) {
      preferences.remove("isConnected");
      preferences.remove("userId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTheme(),
      builder: (context, snapshot) {
        bool activeDarkTheme = snapshot.data ?? false;
        activeDarkThemeNotifier.value = activeDarkTheme;
        return FutureBuilder(
          future: getIfConnected(),
          builder: (context, snapshot) {
            bool isConnected = snapshot.data ?? false;

            return FutureBuilder(
              future: getUserId(),
              builder: (context, snapshot) {
                int? userId = snapshot.data;
                if (userId != null) {
                  userIdNotifier.value = userId;
                }
                return ValueListenableBuilder(
                  valueListenable: activeDarkThemeNotifier,
                  builder: (context, activeDark, child) {
                    return MaterialApp(
                      title: 'tachKil',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        brightness: activeDark
                            ? Brightness.dark
                            : Brightness.light,
                        primaryColor: mainColor,
                      ),
                      home: isConnected ? HomePage() : WelcomePage(),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
