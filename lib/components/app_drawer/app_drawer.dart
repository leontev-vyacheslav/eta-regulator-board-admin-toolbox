import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/components/app_drawer/app_drawer_header.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_paths.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_exit_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/about_dialog.dart' as about_dialog;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../../data_access/backup_repository.dart';

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
              leading: const Icon(Icons.backup_outlined),
              title: const Text(AppStrings.menuGetBackup),
              visualDensity: const VisualDensity(vertical: 2),
              onTap: () async {
                var repository = getIt<BackupRepository>();
                var downloadedFile = await repository.get();
                if (downloadedFile != null) {
                  downloadedFile.fileName =
                      '${AppConsts.appName}_${basenameWithoutExtension(downloadedFile.fileName)}_${DateFormat('yyyyMMddTHms').format(DateTime.now().toUtc())}${extension(downloadedFile.fileName)}';
                  AppToast.show(context, ToastTypes.success, AppStrings.messageBackupReceived);

                  String? outputFile;
                  if (PlatformInfo.isDesktopOS()) {
                    outputFile = await FilePicker.platform.saveFile(
                        dialogTitle: AppStrings.dialogTitleSaveFilePicker,
                        fileName: downloadedFile.fileName,
                        allowedExtensions: ['*.sqlite3']);
                  } else if (!kIsWeb && Platform.isAndroid) {
                    var directory = Directory(AppPaths.androidDownloadFolder);
                    outputFile = '${directory.path}/${downloadedFile.fileName}';
                  } else {
                    var directory = await getApplicationDocumentsDirectory();
                    outputFile = '${directory.path}/${downloadedFile.fileName}';
                  }

                  if (outputFile != null) {
                    var file = File(outputFile);
                    file.writeAsBytes(downloadedFile.buffer).then((value) {
                      AppToast.show(context, ToastTypes.success, AppStrings.messageBackupSaved);
                    });
                  }
                }
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
}
