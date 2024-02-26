import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/material.dart';

// import 'package:socket_io_client/socket_io_client.dart' as IO;

class DeploymentDialog extends AppBaseDialog {
  // IO.Socket? socket;

  DeploymentDialog({super.key, required super.context, required super.titleText}) {
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
  Widget? get content => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                      child: Text(
                    'Deployment log',
                  )),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: () async {},
                          child: const Row(children: [
                            Icon(Icons.wifi),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Check connection')
                          ]),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(
                width: 640,
                height: 200,
                child: TextField(
                  maxLines: null, // Set this
                  expands: true, // and this
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
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
