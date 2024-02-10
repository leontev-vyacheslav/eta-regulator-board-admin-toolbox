import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({super.key});

  static SharedPreferences? localStorage;

  static Future initAsync() async {
    localStorage = await SharedPreferences.getInstance();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ETA Regulator Board Admin',
      theme: ThemeData.dark(),
      home: const HomePage(title: 'ETA Regulator Board Admin'),
      themeMode: ThemeMode.dark,
    );
  }
}
