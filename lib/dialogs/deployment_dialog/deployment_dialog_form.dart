import 'package:eta_regulator_board_admin_toolbox/dialogs/deployment_dialog/deployment_dialog_command_menu.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/deployment_dialog/deployment_dialog_form_context.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:provider/provider.dart';

class DeploymentDialogForm extends StatefulWidget {
  final RegulatorDeviceModel device;
  final BuildContext context;

  const DeploymentDialogForm({
    super.key,
    required this.context,
    required this.device,
  });

  @override
  State<StatefulWidget> createState() => _DeploymentDialogFormState();
}

class _DeploymentDialogFormState extends State<DeploymentDialogForm> {
  RegulatorDeviceModel? _device;

  @override
  void initState() {
    _device = widget.device;
    // _checkConnection();
    context.read<DeploymentDialogFormContext>().deviceAddressTextEditingController.text = _device!.name;

    super.initState();
  }

  Widget buildPopupMenu() {
    return Row(
      children: [
        Expanded(
            child: Text(
          'Deployment log of "${_device!.name}" device:',
        )),
        DeploymentDialogCommandMenu(device: widget.device, context: context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            TextFormField(
              controller: context.read<DeploymentDialogFormContext>().deviceAddressTextEditingController,
              onSaved: (currentAddress) {},
              decoration: const InputDecoration(labelText: 'Device DNS/IP address'),
            ),
            const SizedBox(
              height: 40,
            ),
            buildPopupMenu(),
            SizedBox(
              width: 640,
              height: 200,
              child: TextField(
                decoration: InputDecoration(fillColor: Theme.of(widget.context).primaryColor, filled: true),
                style: TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 14,
                    backgroundColor: Theme.of(widget.context).primaryColor,
                    color: Colors.white70),
                controller: context.read<DeploymentDialogFormContext>().textEditingController,
                scrollController: context.read<DeploymentDialogFormContext>().textFieldScrollController,
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
