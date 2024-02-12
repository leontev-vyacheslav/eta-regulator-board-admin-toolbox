import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_app/app.dart';
import 'package:flutter_test_app/components/app_drawer_header.dart';
import 'package:flutter_test_app/constants/app_strings.dart';
import 'package:flutter_test_app/dialogs/about_dialog.dart' as about_dialog;
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';
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
          ListTile(
              leading: const Icon(Icons.upload),
              title: const Text(AppStrings.menuUpload),
              visualDensity: const VisualDensity(vertical: 2),
              onTap: () async {
                await uploadDevices();
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
    var outputFile = await FilePicker.platform
        .saveFile(dialogTitle: 'Please select an output file:', fileName: 'devices.json', allowedExtensions: ['json']);

    if (outputFile != null) {
      var file = File(outputFile);
      if (!context.mounted) {
        return;
      }
      var jsonDevices = App.of(context).localStorage.getString('devices');
      if (jsonDevices != null) {
        await file.writeAsString(jsonDevices);
      }
    }
  }

  Future<void> uploadDevices() async {
    var pickerResult = await FilePicker.platform
        .pickFiles(dialogTitle: 'Please select a file:', allowedExtensions: ['json'], allowMultiple: false);

    if (pickerResult != null && pickerResult.files.isNotEmpty) {
      var file = File(pickerResult.files[0].path!);

      var jsonDevices = await file.readAsString();

      if (context.mounted) {
        await App.of(context).localStorage.setString('devices', jsonDevices);
        // ignore: use_build_context_synchronously
        await Navigator.popAndPushNamed(context, '/');
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
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () async {
                    if (Platform.isWindows || Platform.isLinux) {
                      await windowManager.close();
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  child: const Text(AppStrings.buttonOk)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.buttonCancel))
            ],
            content: const SizedBox(width: 480, child: Text(AppStrings.appTitle)),
          );
        });
  }
}
