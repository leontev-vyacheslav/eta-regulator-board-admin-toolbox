import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegulatorDeviceDialogForm extends SizedBox {
  final RegulatorDeviceModel? device;

  const RegulatorDeviceDialogForm({super.key, this.device});

  @override
  double? get width => 640;

  @override
  Widget? get child => Wrap(
        runSpacing: 20,
        children: [
          TextFormField(
              initialValue: device?.id,
              readOnly: device != null,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Id',
                  suffix: IconButton(
                    style: const ButtonStyle(enableFeedback: false),
                    onPressed: device == null ? () {} : null,
                    icon: const Icon(Icons.refresh),
                  ))),
          TextFormField(
            initialValue: device?.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Device name',
            ),
          ),
          TextFormField(
            initialValue: device?.macAddress,
            inputFormatters: [
              MaskTextInputFormatter(mask: '##:##:##:##:##:##', filter: {"#": RegExp(r'[0-9a-fA-F]')}, type: MaskAutoCompletionType.lazy)
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'MAC address',
            ),
          ),
          TextFormField(
              initialValue: device?.masterKey,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Master key',
                  suffix: IconButton(
                    style: const ButtonStyle(enableFeedback: false),
                    onPressed: device != null ? () {} : null,
                    icon: const Icon(Icons.refresh),
                  ))),
        ],
      );
}
