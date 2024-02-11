import 'package:flutter/material.dart';
import 'package:flutter_test_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  static SharedPreferences? localStorage;

  const App({super.key});

  static Future initAsync() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;
}

class AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.dark;
  final String _appTitle = 'ETA Regulator Board Admin';

  @override
  void initState() {
    _themeMode = ThemeMode.values.byName(App.localStorage?.getString('theme') ?? 'dark');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: HomePage(title: _appTitle),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeMode get themeMode => _themeMode;

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

    App.localStorage?.setString('theme', _themeMode.name);
  }
}
