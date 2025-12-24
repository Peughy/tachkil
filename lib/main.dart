import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/pages/login_page.dart';
import 'package:tachkil/src/utils/common.dart';
// import 'package:tachkil/src/pages/register_page.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
// import 'package:tachkil/src/widgets/loading_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
                    brightness: activeDark ? Brightness.dark : Brightness.light,
                    primaryColor: mainColor,
                  ),
                  home: isConnected ? HomePage() : LoginPage(),
                );
              },
            );
          },
        );
      },
    );
  }
}
