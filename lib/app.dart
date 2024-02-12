import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants/app_strings.dart';
import 'package:flutter_test_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  final SharedPreferences localStorage;

  const App({super.key, required this.localStorage});

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;
}

class AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    _themeMode = ThemeMode.values.byName(widget.localStorage.getString('theme') ?? 'dark');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(title: AppStrings.appTitle),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeMode get themeMode => _themeMode;

  SharedPreferences get localStorage => widget.localStorage;

  set themeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void toggleTheme() {
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }

    localStorage.setString('theme', _themeMode.name);
  }
}
