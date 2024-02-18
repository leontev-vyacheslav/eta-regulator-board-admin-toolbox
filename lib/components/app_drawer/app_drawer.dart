import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/components/app_drawer/app_drawer_header.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/about_dialog.dart' as about_dialog;
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

class AppDrawer extends Drawer {
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawer({required this.scaffoldKey, required this.context, super.key});

  @override
  Widget? get child => ListView(
        padding: EdgeInsets.zero,
        children: [
          AppDrawerHeader(scaffoldKey: scaffoldKey),
          ListTile(
              leading: const Icon(Icons.download),
              title: const Text(AppStrings.menuDownload),
              visualDensity: const VisualDensity(vertical: 2),
              onTap: () async {
                await downloadDevices();
              }),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text(AppStrings.menuAbout),
            visualDensity: const VisualDensity(vertical: 2),
            onTap: () {
              showAboutDialog();
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(
                App.of(context).themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            title: Text(App.of(context).themeMode == ThemeMode.dark ? 'Light theme' : 'Dark theme'),
            onTap: () {
              App.of(context).toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(AppStrings.menuExit),
            visualDensity: const VisualDensity(vertical: 2),
            onTap: () async {
              showAppExitConfirmDialog();
            },
          ),
        ],
      );

  Future<void> downloadDevices() async {
    String? outputFile;
    if (PlatformInfo.isDesktopOS) {
      outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Please select an output file:', fileName: 'devices.json', allowedExtensions: ['json']);
    } else if (Platform.isAndroid) {
      var directory = Directory("/storage/emulated/0/Download");
      outputFile = '${directory.path}/devices.json';
    } else {
      var directory = await getApplicationDocumentsDirectory();
      outputFile = '${directory.path}/devices.json';
    }

    if (context.mounted) {
      var devices = await RegulatorDeviceRepository().getList();
      var jsonDevices = jsonEncode(devices);

      if (outputFile != null) {
        var file = File(outputFile);
        await file.writeAsString(jsonDevices);
      }
    }
  }

  void showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return about_dialog.AboutDialog(context: context, titleText: AppStrings.menuAbout);
      },
    );
  }

  void showAppExitConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppBaseDialog(
            titleText: 'Confirm',
            context: context,
            actions: [
              AppElevatedButton(
                  onPressed: () async {
                    if (Platform.isWindows || Platform.isLinux) {
                      await windowManager.close();
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  child: const Text(AppStrings.buttonOk)),
              AppElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.buttonCancel))
            ],
            content: const SizedBox(width: 480, child: Text(AppStrings.confirmAppExit)),
          );
        });
  }
}
