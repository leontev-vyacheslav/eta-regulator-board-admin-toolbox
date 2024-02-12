import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/window_drag_area.dart';
import 'package:flutter_test_app/constants/app_strings.dart';
import 'package:window_manager/window_manager.dart';

import '../constants/app_colors.dart';

class AppTitleBar extends Row {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppTitleBar({required this.scaffoldKey, super.key});

  @override
  List<Widget> get children => [
        Expanded(
            child: WindowDragArea(
          maximizable: true,
          child: Row(children: [
            IconButton(
                iconSize: 32,
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  scaffoldKey.currentState!.openDrawer();
                }),
            const Expanded(
              child: Text(AppStrings.appTitle,
                  textAlign: TextAlign.center, style: TextStyle(color: AppColors.textAccent, fontSize: 24)),
            ),
            IconButton(
                iconSize: 32,
                icon: const Icon(Icons.close),
                onPressed: () async {
                  await windowManager.close();
                }),
          ]),
        )),
      ];
}
