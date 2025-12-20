import 'package:flutter/material.dart';
import 'package:tachkil/src/home_page.dart';
import 'package:tachkil/utils/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tachKil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: mainColor),
      ),
      home: const HomePage(),
    );
  }
}

