import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/material.dart';

import 'regulator_device_dialog_form.dart';

class RegulatorDeviceDialog extends AppBaseDialog {
  final RegulatorDeviceModel? device;
  final _formKey = GlobalKey<FormState>();

  RegulatorDeviceDialog({super.key, required super.context, required super.titleText, this.device});

  @override
  List<Widget> get actions => [
        AppElevatedButton(
            child: AppElevatedButtonLabel(
              label: device!.id.isNotEmpty ? 'UPDATE' : 'CREATE',
              icon: Icons.check,
              color: AppColors.textAccent,
            ),
            onPressed: () async {
              if (_formKey.currentState != null) {
                _formKey.currentState!.save();
              }

              if (!context.mounted) {
                return;
              }
              Navigator.pop<DialogResult>(
                  context, DialogResult<RegulatorDeviceModel?>(result: ModalResults.ok, value: device));
            }),
        AppElevatedButton(
            onPressed: () {
              Navigator.pop<DialogResult<RegulatorDeviceModel?>>(
                  context, DialogResult(result: ModalResults.cancel, value: null));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonCancel,
              icon: Icons.close,
            ))
      ];

  @override
  Widget? get content => RegulatorDeviceDialogForm(
        formKey: _formKey,
        device: device,
      );
}
