import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class AppExitDialog extends AppBaseDialog {
  const AppExitDialog({super.key, required super.context, required super.titleText});

  @override
  Widget? get content => const SizedBox(width: 480, child: Text(AppStrings.confirmAppExit));

  @override
  List<Widget> get actions => [
        AppElevatedButton(
            onPressed: () async {
              if (Platform.isWindows || Platform.isLinux) {
                await windowManager.close();
              } else {
                SystemNavigator.pop();
              }
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonOk,
              icon: Icons.check,
              color: AppColors.textAccent,
            )),
        AppElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonCancel,
              icon: Icons.close,
            ))
      ];
}
