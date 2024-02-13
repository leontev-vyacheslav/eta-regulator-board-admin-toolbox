import 'package:flutter/material.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegulatorDeviceDialogForm extends Form {
  final RegulatorDeviceModel? device;

  RegulatorDeviceDialogForm({super.key, this.device}) : super(child: Container());

  @override
  Widget get child => SizedBox(
      width: 640,
      child: Wrap(
        runSpacing: 20,
        children: [
          TextFormField(
              initialValue: device?.id,
              onSaved: (currentId) {
                if (currentId != null) {
                  device!.id = currentId;
                }
              },
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
            onSaved: (currentName) {
              if (currentName != null) {
                device!.name = currentName;
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Device name',
            ),
          ),
          TextFormField(
            initialValue: device?.macAddress,
            onSaved: (currentMacAddress) {
              if (currentMacAddress != null) {
                device!.macAddress = currentMacAddress;
              }
            },
            inputFormatters: [
              MaskTextInputFormatter(
                  mask: '##:##:##:##:##:##', filter: {"#": RegExp(r'[0-9a-fA-F]')}, type: MaskAutoCompletionType.lazy)
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'MAC address',
            ),
          ),
          TextFormField(
              initialValue: device?.masterKey,
              onSaved: (currentMasterKey) {
                if (currentMasterKey != null) {
                  device!.masterKey = currentMasterKey;
                }
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Master key',
                  suffix: IconButton(
                    style: const ButtonStyle(enableFeedback: false),
                    onPressed: device != null ? () {} : null,
                    icon: const Icon(Icons.refresh),
                  ))),
        ],
      ));
}
