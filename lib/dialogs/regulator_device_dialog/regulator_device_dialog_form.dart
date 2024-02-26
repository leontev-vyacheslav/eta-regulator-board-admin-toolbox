import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class RegulatorDeviceDialogForm extends StatefulWidget {
  final Key? formKey;
  final RegulatorDeviceModel? device;

  const RegulatorDeviceDialogForm({
    super.key,
    this.formKey,
    this.device,
  });

  @override
  State<StatefulWidget> createState() => _RegulatorDeviceDialogFormState();
}

class _RegulatorDeviceDialogFormState extends State<RegulatorDeviceDialogForm> {
  RegulatorDeviceModel? _device;
  Key? _formKey;
  TextEditingController? _idTextEditingController;
  TextEditingController? _nameTextEditingController;
  TextEditingController? _macAddressTextEditingController;
  TextEditingController? _masterKeyTextEditingController;
  bool _createMode = false;

  @override
  void initState() {
    _createMode = widget.device!.id.isEmpty;
    _device = widget.device;
    _formKey = widget.formKey;

    _idTextEditingController = TextEditingController(text: _device?.id);
    _nameTextEditingController = TextEditingController(text: _device?.name);
    _macAddressTextEditingController = TextEditingController(text: _device?.macAddress);
    _masterKeyTextEditingController = TextEditingController(text: _device?.masterKey);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: SizedBox(
            width: 640,
            child: Wrap(
              runSpacing: 20,
              children: [
                TextFormField(
                    controller: _idTextEditingController,
                    onSaved: (currentId) {
                      if (currentId != null) {
                        _device!.id = currentId;
                      }
                    },
                    readOnly: _device!.id.isNotEmpty,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Id',
                        suffix: IconButton(
                          style: const ButtonStyle(enableFeedback: false),
                          onPressed: _createMode
                              ? () {
                                  var uuid = const Uuid();
                                  _idTextEditingController?.text = uuid.v4().toLowerCase();
                                }
                              : null,
                          icon: const Icon(Icons.refresh),
                        ))),
                TextFormField(
                  controller: _nameTextEditingController,
                  onSaved: (currentName) {
                    if (currentName != null) {
                      _device!.name = currentName;
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Device name',
                  ),
                ),
                TextFormField(
                  controller: _macAddressTextEditingController,
                  onSaved: (currentMacAddress) {
                    if (currentMacAddress != null) {
                      _device!.macAddress = currentMacAddress;
                    }
                  },
                  inputFormatters: [
                    MaskTextInputFormatter(
                        mask: '##:##:##:##:##:##',
                        filter: {"#": RegExp(r'[0-9a-fA-F]')},
                        type: MaskAutoCompletionType.lazy)
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'MAC address',
                  ),
                ),
                TextFormField(
                    controller: _masterKeyTextEditingController,
                    onSaved: (currentMasterKey) {
                      if (currentMasterKey != null) {
                        _device!.masterKey = currentMasterKey;
                      }
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Master key',
                        suffix: IconButton(
                          style: const ButtonStyle(enableFeedback: false),
                          onPressed: _createMode
                              ? () {
                                  var random = Random.secure();
                                  var bytes = Uint8List.fromList(List<int>.generate(32, (i) => random.nextInt(255)));
                                  _masterKeyTextEditingController!.text = base64Encode(bytes);
                                }
                              : null,
                          icon: const Icon(Icons.refresh),
                        ))),
              ],
            )),
      ),
    ));
  }

  @override
  void dispose() {
    _idTextEditingController?.dispose();
    _nameTextEditingController?.dispose();
    _macAddressTextEditingController?.dispose();
    _masterKeyTextEditingController?.dispose();

    super.dispose();
  }
}
