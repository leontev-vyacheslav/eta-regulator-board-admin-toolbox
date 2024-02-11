import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/access_token_dialog.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';
import 'package:flutter_test_app/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                _showDeviceQrCode();
              },
              child: const Row(children: [
                Icon(Icons.qr_code),
                SizedBox(
                  width: 10,
                ),
                Text('Device ID QR-code')
              ]),
            ),
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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RegulatorDeviceDialog(
            context: context,
            titleText: 'Edit device',
            device: device,
          );
        });
  }

  void _showDeviceQrCode() async {
    var painter = QrPainter(
      data: device.id,
      // ignore: deprecated_member_use
      emptyColor: Colors.white,
      version: QrVersions.auto,
      dataModuleStyle: const QrDataModuleStyle(
        color: Colors.black,
        dataModuleShape: QrDataModuleShape.square,
      ),
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );

    var imageData = await painter.toImageData(1024, format: ImageByteFormat.png);

    var outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:', fileName: '${device.name}-id.png', allowedExtensions: ['*.png']);

    if (outputFile != null && imageData != null) {
      var file = File(outputFile);
      await file.writeAsBytes(imageData.buffer.asUint8List());
    }
  }
}
