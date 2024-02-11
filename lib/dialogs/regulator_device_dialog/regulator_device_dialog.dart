import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

import 'regulator_device_dialog_form.dart';

class RegulatorDeviceDialog extends AppBaseDialog {
  final RegulatorDeviceModel? device;

  const RegulatorDeviceDialog({super.key, required super.context, required super.titleText, this.device});

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: Text(device != null ? 'UPDATE' : 'CREATE'),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            minimumSize: const Size(120, 40),
            backgroundColor: const Color.fromRGBO(0xff, 0x57, 0x22, 1),
            foregroundColor: const Color.fromRGBO(0xff, 0xff, 0xff, 1),
          ),
          icon: const Icon(Icons.check),
        ),
        ElevatedButton.icon(
          label: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))), minimumSize: const Size(120, 40)),
          icon: const Icon(Icons.close),
        )
      ];

  @override
  Widget? get content => RegulatorDeviceDialogForm(
        device: device,
      );
}
