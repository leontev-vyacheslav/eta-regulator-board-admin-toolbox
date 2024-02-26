import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/pages/home_page.dart';
import 'package:eta_regulator_board_admin_toolbox/notifiers/regulator_devices_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class App extends StatefulWidget {
  final SharedPreferences localStorage;

  const App({super.key, required this.localStorage});

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;
}

class AppState extends State<App> {
  IO.Socket? socket;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    _themeMode = ThemeMode.values.byName(widget.localStorage.getString('theme') ?? 'dark');

    super.initState();

    socket = IO.io('http://192.168.0.107:5020', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    socket!.on('message', (data) {
      debugPrint('Received message: $data');
    });
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  SharedPreferences get localStorage => widget.localStorage;

  Future<void> toggleTheme() async {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    await localStorage.setString('theme', _themeMode.name);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RegulatorDeviceRepository>(create: (_) => RegulatorDeviceRepository()),
        ChangeNotifierProvider(create: (context) => RegulatorDevicesChangeNotifier())
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        themeMode: _themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark)),
        home: const HomePage(title: AppStrings.appTitle),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
