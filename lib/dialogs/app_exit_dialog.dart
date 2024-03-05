import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class AppExitDialog extends AppBaseDialog {
  const AppExitDialog(
      {super.key,
      required super.context,
      super.titleText = AppStrings.dialogTitleConfirm,
      super.titleIcon = Icons.question_answer_outlined});

  @override
  Widget? get content => const SizedBox(width: 480, child: Text(AppStrings.confirmAppExit));
  @override
  @override
  List<Widget> get actions => [
        AppElevatedButton(
            onPressed: () async {
              if (PlatformInfo.isDesktopOS()) {
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

class RemoveRegulatorDeviceDialog extends AppBaseDialog {
  final RegulatorDeviceModel device;

  const RemoveRegulatorDeviceDialog(
      {super.key,
      required super.context,
      required this.device,
      super.titleText = AppStrings.dialogTitleConfirm,
      super.titleIcon = Icons.question_answer_outlined});

  @override
  Widget? get content =>
      SizedBox(width: 480, child: Text(AppStrings.confirmRemoveDevice.replaceAll('%device%', device.name)));

  @override
  List<Widget>? get actions => [
        AppElevatedButton(
            onPressed: () async {
              Navigator.pop<DialogResult>(
                  context, DialogResult<RegulatorDeviceModel?>(result: ModalResults.ok, value: device));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonOk,
              icon: Icons.check,
              color: AppColors.textAccent,
            )),
        AppElevatedButton(
            onPressed: () {
              Navigator.pop<DialogResult>(context, DialogResult<RegulatorDeviceModel?>(result: ModalResults.cancel));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonCancel,
              icon: Icons.close,
            ))
      ];
}
