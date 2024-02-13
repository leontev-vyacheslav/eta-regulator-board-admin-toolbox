import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile.dart';
import 'package:flutter_test_app/constants/app_strings.dart';
import 'package:flutter_test_app/dialogs/access_token_dialog.dart';
import 'package:flutter_test_app/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:flutter_test_app/models/dialog_result.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RegulatorDeviceListTileMenu extends StatelessWidget {
  final BuildContext context;
  final RegulatorDeviceModel device;
  final UpdateCallbackFunction? updateCallback;

  const RegulatorDeviceListTileMenu({super.key, required this.context, required this.device, this.updateCallback});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            onTap: () async {
              await _showRegulatorDeviceDialog();
            },
            child: const Row(children: [
              Icon(Icons.edit),
              SizedBox(
                width: 10,
              ),
              Text(AppStrings.menuEditDevice)
            ]),
          ),
          PopupMenuItem(
            onTap: () {
              _showDeviceQrCode();
            },
            child: const Row(children: [
              Icon(Icons.qr_code),
              SizedBox(
                width: 10,
              ),
              Text(AppStrings.menuQRCodeId)
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
              onTap: () async {
                await _showAccessTokenDialog();
              },
              child: const Row(children: [
                Icon(Icons.key),
                SizedBox(
                  width: 10,
                ),
                Text(AppStrings.menuCreateAccessToken)
              ])),
        ];
      },
    );
  }

  Future<void> _showAccessTokenDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AccessTokenDialog(
            context: context,
            titleText: AppStrings.dialogTitleAccessToken,
            device: device,
          );
        });
  }

  Future<void> _showRegulatorDeviceDialog() async {
    var dialogResult = await showDialog<DialogResult>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RegulatorDeviceDialog(
            context: context,
            titleText: AppStrings.dialogTitleEditDevice,
            device: device,
          );
        });

    if (dialogResult?.result == ModalResults.ok && updateCallback != null) {
      updateCallback!(device);
    }
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
