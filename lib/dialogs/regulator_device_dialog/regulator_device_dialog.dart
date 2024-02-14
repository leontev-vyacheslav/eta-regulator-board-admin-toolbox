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
        ElevatedButton.icon(
          label: Text(device != null ? 'UPDATE' : 'CREATE'),
          onPressed: () async {
            if (_formKey.currentState != null) {
              _formKey.currentState!.save();
            }

            if (!context.mounted) {
              return;
            }
            Navigator.pop<DialogResult>(context, DialogResult<RegulatorDeviceModel>(result: ModalResults.ok, value: device));
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            minimumSize: const Size(120, 40),
            backgroundColor: AppColors.textAccent,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.check),
        ),
        ElevatedButton.icon(
          label: const Text(AppStrings.buttonCancel),
          onPressed: () {
            Navigator.pop<DialogResult>(context, DialogResult(result: ModalResults.cancel));
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              minimumSize: const Size(120, 40)),
          icon: const Icon(Icons.close),
        )
      ];

  @override
  Widget? get content => RegulatorDeviceDialogForm(
        formKey: _formKey,
        device: device,
      );
}
