import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_app/app.dart';
import 'package:flutter_test_app/components/app_drawer_header.dart';
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
              title: const Text('Download'),
              visualDensity: const VisualDensity(vertical: 2),
              onTap: () {
                debugPrint('Download');
              }),
          ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Upload'),
              visualDensity: const VisualDensity(vertical: 2),
              onTap: () {
                debugPrint('Upload');
              }),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.app_registration),
            title: const Text('About'),
            visualDensity: const VisualDensity(vertical: 2),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return about_dialog.AboutDialog(context: context, titleText: 'About');
                },
              );
            },
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(App.of(context).themeMode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            title: Text(App.of(context).themeMode == ThemeMode.dark ? 'Light theme' : 'Dark theme'),
            onTap: () {
              App.of(context).toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            visualDensity: const VisualDensity(vertical: 2),
            onTap: () async {
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
                            child: const Text('OK')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('CANCEL'))
                      ],
                      content: const SizedBox(width: 480, child: Text('Do you really want to exit app?')),
                    );
                  });
            },
          ),
        ],
      );
}
