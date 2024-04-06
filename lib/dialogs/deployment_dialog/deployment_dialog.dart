import 'package:eta_regulator_board_admin_toolbox/dialogs/deployment_dialog/deployment_dialog_form_context.dart';
import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:provider/provider.dart';

import 'deployment_dialog_form.dart';

class DeploymentDialog extends AppBaseDialog {
  final RegulatorDeviceModel device;

  const DeploymentDialog(
      {super.key,
      required super.context,
      required super.titleText,
      super.titleIcon = Icons.install_desktop_outlined,
      required this.device});

  @override
  Widget? get content => Provider<DeploymentDialogFormContext>(
        create: (_) => DeploymentDialogFormContext(),
        child: DeploymentDialogForm(
          device: device,
          context: context,
        ),
      );

  @override
  List<Widget>? get actions => [
        AppElevatedButton(
            onPressed: () {
              Navigator.pop<DialogResult<RegulatorDeviceModel?>>(
                  context, DialogResult(result: ModalResults.cancel, value: null));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonClose,
              icon: Icons.close,
            ))
      ];
}
