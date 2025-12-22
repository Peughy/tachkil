import 'package:flutter/material.dart';
import 'package:tachkil/src/pages/home_page.dart';
import 'package:tachkil/src/utils/constant.dart';
import 'package:tachkil/src/utils/notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeDarkThemeNotifier,
      builder: (context, activeDark, child) {
        return MaterialApp(
          title: 'tachKil',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: activeDark ? Brightness.dark : Brightness.light,
            primaryColor: mainColor
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
