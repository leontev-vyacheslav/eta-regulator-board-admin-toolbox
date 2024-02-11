import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

class RegulatorDeviceDialog extends AppBaseDialog {
  final RegulatorDeviceModel device;

  const RegulatorDeviceDialog({super.key, required super.context, required super.titleText, required this.device});

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))), minimumSize: const Size(120, 40)),
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
  Widget? get content => const SizedBox(
      width: 640,
      child: Wrap(
        runSpacing: 20,
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Device name',
            ),
          ),
          TextField(
              decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'MAC address',
          )),
          TextField(
              decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Master key',
          )),
        ],
      ));
}
