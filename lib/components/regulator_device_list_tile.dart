import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/access_token_dialog.dart';
import 'package:flutter_test_app/dialogs/regulator_device_dialog.dart';

import '../models/regulator_device_model.dart';

class RegulatorDeviceListTile extends ListTile {
  final RegulatorDeviceModel device;
  final BuildContext context;

  const RegulatorDeviceListTile({required this.context, required this.device, super.key});

  @override
  Widget? get leading => const Icon(Icons.devices);

  @override
  Widget? get title => Text(device.name);

  @override
  GestureTapCallback? get onTap => () {
        debugPrint(device.id);
      };

  @override
  VisualDensity? get visualDensity => const VisualDensity(vertical: 2);

  @override
  Widget? get trailing => PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              onTap: () {
                _showRegulatorVDeviceDialog();
              },
              child: const Row(children: [
                Icon(Icons.edit),
                SizedBox(
                  width: 10,
                ),
                Text('Edit device')
              ]),
            ),
            PopupMenuItem(
                onTap: () {},
                height: 1,
                child: const Divider(
                  height: 1,
                  thickness: 1,
                )),
            PopupMenuItem(
                onTap: () {
                  _showAccessTokenDialog();
                },
                child: const Row(children: [
                  Icon(Icons.key),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Create access token')
                ])),
          ];
        },
      );

  void _showAccessTokenDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AccessTokenDialog(
            context: context,
            titleText: 'Create access token',
            device: device,
          );
        });
  }

  void _showRegulatorVDeviceDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RegulatorDeviceDialog(
            context: context,
            titleText: 'Edit device',
            device: device,
          );
        });
  }
}
