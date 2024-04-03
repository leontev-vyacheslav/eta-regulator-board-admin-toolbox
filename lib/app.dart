import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/auth_user_model.dart';
import 'package:eta_regulator_board_admin_toolbox/notifiers/regulator_devices_change_notifier.dart';
import 'package:eta_regulator_board_admin_toolbox/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  final SharedPreferences localStorage;

  const App({super.key, required this.localStorage});

  @override
  AppState createState() => AppState();

  static AppState of(BuildContext context) => context.findAncestorStateOfType<AppState>()!;

  static AuthUserModel? authUser;

  static void unauthorize() {
    App.authUser = null;
  }
}

class AppState extends State<App> {
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    _themeMode = ThemeMode.values.byName(widget.localStorage.getString('theme') ?? 'dark');

    super.initState();
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
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.transparent,
        overlayWidgetBuilder: (_) {
          return const Center(
            child: SpinKitWave(
              color: AppColors.textAccent,
              size: 50.0,
              type: SpinKitWaveType.start,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
        child: MaterialApp(
          title: AppConsts.appTitle,
          themeMode: _themeMode,
          theme: ThemeData.light(),
          darkTheme:
              ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark)),
          home: const LoginPage(),
          debugShowCheckedModeBanner: false,
          navigatorKey: globalNavigatorKey,
        ),
      ),
    );
  }
}
