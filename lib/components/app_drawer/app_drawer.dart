import 'dart:io';

import 'package:archive/archive.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_drawer/app_drawer_header.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_exit_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/file_helper.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/about_dialog.dart' as about_dialog;
import 'package:path/path.dart';

import '../../data_access/deployment_package_repository.dart';

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
                await FileHelper.downloadDevices().then((value) {
                  if (value) {
                    AppToast.show(
                        context, ToastTypes.success, 'Regulator device list saved to a json file successfully.');
                  }
                });
              }),
          ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text(AppStrings.menuUpload),
              visualDensity: const VisualDensity(vertical: 2),
              onTap: () async {
                await _getAppPackage();
              }),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text(AppStrings.menuAbout),
            visualDensity: const VisualDensity(vertical: 2),
            onTap: () async {
              await _showAboutDialog();
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
              App.of(context).toggleTheme().then((value) {
                AppToast.show(
                    context, ToastTypes.info, 'Theme was changed to ${App.of(context).themeMode.name.toUpperCase()}');
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(AppStrings.menuExit),
            visualDensity: const VisualDensity(vertical: 2),
            onTap: () async {
              await _showAppExitConfirmDialog();
            },
          ),
        ],
      );

  Future<void> _showAboutDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return about_dialog.AboutDialog(
            context: context, titleText: AppStrings.menuAbout, titleIcon: Icons.app_registration);
      },
    );
  }

  Future<void> _showAppExitConfirmDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppExitDialog(context: context);
        });
  }

  Future<void> _getAppPackage({bool loadOnServer = false}) async {
    var pickerResult = await FilePicker.platform.pickFiles(
        dialogTitle: 'Please select a file:', allowedExtensions: ['zip'], allowMultiple: false, type: FileType.custom);

    if (pickerResult != null && pickerResult.files.isNotEmpty) {
      var archiveFile = File(pickerResult.files[0].path!);

      var archiveBuffer = await archiveFile.readAsBytes();

      if (loadOnServer) {
        var repository = getIt<DeploymentPackageRepository>();
        repository.uploadDeploymentPackager(archiveBuffer, pickerResult.files[0].name);
      }

      var archive = ZipDecoder().decodeBytes(archiveBuffer);
      var basePath = 'assets/deployment/distributable/${basenameWithoutExtension(archiveFile.path)}';

      if (await Directory(basePath).exists()) {
        AppToast.show(context, ToastTypes.warning, 'The installation package exists already.',
            duration: const Duration(seconds: 5));

        return;
      }

      for (final file in archive) {
        final filename = file.name;
        var path = '$basePath/$filename';
        if (file.isFile) {
          final data = file.content as List<int>;
          File(path)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(path).create(recursive: true);
        }
      }

      AppToast.show(context, ToastTypes.success, 'The installation package was successfully unzipped.');
    }
  }
}
