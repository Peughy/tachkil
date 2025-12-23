import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/pages/login_page.dart';
import 'package:tachkil/src/pages/register_page.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';
import 'package:tachkil/src/widgets/loading_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // get the connected statut stock with the sharedPreference
  Future<bool> getIfConnected() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("isConnected") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIfConnected(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // when the data loading display loading page
          return LoadingWidget();
        }

        bool isConnected = snapshot.data!;

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
  }
}
