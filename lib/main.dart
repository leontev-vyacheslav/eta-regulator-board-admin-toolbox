import 'package:eta_regulator_board_admin_toolbox/data_access/app_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/auth_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

import 'package:get_it/get_it.dart';

import 'data_access/backup_repository.dart';
import 'data_access/deployment_package_repository.dart';

final getIt = GetIt.instance;
final globalNavigatorKey = GlobalKey<NavigatorState>();

void configureDependencies() {
  getIt.registerFactory<AppHttpClientFactory>(() => AppHttpClientFactory());
  getIt.registerFactory<RegulatorDeviceRepository>(() => RegulatorDeviceRepository());
  getIt.registerFactory<DeploymentPackageRepository>(() => DeploymentPackageRepository());
  getIt.registerFactory<BackupRepository>(() => BackupRepository());
  getIt.registerFactory<AuthRepository>(() => AuthRepository());
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  if (PlatformInfo.isDesktopOS()) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(1024, 768),
      maximumSize: Size(1024, 768),
      size: Size(1024, 768),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  configureDependencies();
  runApp(App(localStorage: await SharedPreferences.getInstance()));
}
