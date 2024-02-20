import 'dart:io';
import 'dart:ui';

import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/access_token_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
            child: const Row(children: [
              Icon(Icons.edit_outlined),
              SizedBox(
                width: 10,
              ),
              Text(AppStrings.menuEditDevice)
            ]),
            onTap: () async {
              await _showRegulatorDeviceDialog();
            },
          ),
          PopupMenuItem(
            child: const Row(children: [
              Icon(Icons.delete_outline),
              SizedBox(
                width: 10,
              ),
              Text(AppStrings.menuRemoveDevice)
            ]),
            onTap: () async {
              await _showDeleteRegulatorDevice();
            },
          ),
          PopupMenuItem(
              onTap: () {},
              height: 1,
              child: const Divider(
                height: 1,
                thickness: 1,
              )),
          PopupMenuItem(
            child: const Row(children: [
              Icon(Icons.qr_code),
              SizedBox(
                width: 10,
              ),
              Text(AppStrings.menuQRCodeId)
            ]),
            onTap: () async {
              await _saveDeviceQrCode();
            },
          ),
          PopupMenuItem(
              onTap: () {},
              height: 1,
              child: const Divider(
                height: 1,
                thickness: 1,
              )),
          PopupMenuItem(
            child: const Row(children: [
              Icon(Icons.key),
              SizedBox(
                width: 10,
              ),
              Text(AppStrings.menuCreateAccessToken)
            ]),
            onTap: () async {
              await _showAccessTokenDialog();
            },
          ),
        ];
      },
    );
  }

  Future<void> _showDeleteRegulatorDevice() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AppBaseDialog(
            titleText: AppStrings.dialogTitleConfirm,
            context: context,
            actions: [
              AppElevatedButton(
                  onPressed: () async {
                    updateCallback!(device: device, operation: UpdateCallbackOperations.delete);
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.buttonOk)),
              AppElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.buttonCancel))
            ],
            content: const SizedBox(width: 480, child: Text(AppStrings.confirmRemoveDevice)),
          );
        });
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
      updateCallback!(device: device, operation: UpdateCallbackOperations.put);
    }
  }

  Future<void> _saveDeviceQrCode() async {
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

    if (imageData != null) {
      String? outputFile;
      if (PlatformInfo.isDesktopOS) {
        outputFile = await FilePicker.platform.saveFile(
            dialogTitle: 'Please select an output file:', fileName: '${device.name}.png', allowedExtensions: ['*.png']);
      } else if (Platform.isAndroid) {
        var directory = Directory("/storage/emulated/0/Download");
        outputFile = '${directory.path}/${device.name}.png';
      } else {
        var directory = await getApplicationDocumentsDirectory();
        outputFile = '${directory.path}/${device.name}.png';
      }

      if (outputFile != null) {
        var file = File(outputFile);
        await file.writeAsBytes(imageData.buffer.asUint8List());
      }
    }
  }
}
