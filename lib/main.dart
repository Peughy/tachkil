import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/pages/welcome_page.dart';
import 'package:tachkil/src/utils/common.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _activeDarkTheme = false;
  bool _isConnected = false;
  int? _userId;

  // Loading and initialize data
  void _loadAppData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isConnected = preferences.getBool("isConnected") ?? false;
    bool activeDarkTheme = preferences.getBool("isDarkTheme") ?? false;
    int? id = await getUserId();

    setState(() {
      _isConnected = isConnected;
      _activeDarkTheme = activeDarkTheme;
      _userId = id;
      _isLoading = false;
    });

    // Update the global notifier
    activeDarkThemeNotifier.value = _activeDarkTheme;
    userIdNotifier.value = _userId;
  }

  @override
  void initState() {
    _loadAppData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return loadingWidget(false);
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
          home: _isConnected ? HomePage() : WelcomePage(),
        );
      },
    );
  }
}
