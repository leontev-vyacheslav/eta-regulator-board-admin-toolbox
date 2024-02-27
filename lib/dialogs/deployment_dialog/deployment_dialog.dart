
import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';

import 'deployment_dialog_form.dart';

class DeploymentDialog extends AppBaseDialog {
  // IO.Socket? socket;
  final RegulatorDeviceModel device;

  DeploymentDialog({super.key, required super.context, required super.titleText, required this.device}) {
    // socket = IO.io('http://192.168.0.107:5020', <String, dynamic>{
    //     'transports': ['websocket'],
    //     'autoConnect': false,
    //   });
  }

  // socket!.connect();
  // socket!.on('message', (data) {
  //   debugPrint('Received message: $data');
  // });

  @override
  Widget? get content => DeploymentDialogForm(device: device);

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
