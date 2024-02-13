import 'package:eta_regulator_board_admin_toolbox/components/window_drag_area.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../constants/app_colors.dart';

class AppTitleBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppTitleBar({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        ))
      ],
    );
  }
}
