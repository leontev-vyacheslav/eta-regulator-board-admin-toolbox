
import 'package:eta_regulator_board_admin_toolbox/components/app_drawer/app_drawer_header.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_exit_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/file_helper.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/about_dialog.dart' as about_dialog;


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
