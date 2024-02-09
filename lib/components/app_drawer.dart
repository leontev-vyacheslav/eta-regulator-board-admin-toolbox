import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_app/components/app_drawer_header.dart';
import 'package:flutter_test_app/dialogs/about_dialog.dart' as about_dialog;
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
            leading: const Icon(Icons.home),
            title: const Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return about_dialog.AboutDialog(context: context, titleText: 'About');
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            onTap: () async {
              if (Platform.isWindows || Platform.isLinux) {
                await windowManager.close();
              } else {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      );
}
