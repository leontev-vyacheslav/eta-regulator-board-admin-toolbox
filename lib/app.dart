import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

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
