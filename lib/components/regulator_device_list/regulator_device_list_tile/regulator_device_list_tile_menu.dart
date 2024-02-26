import 'dart:io';
import 'dart:ui';

import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/access_token_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/deployment_dialog.dart/deployment_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/notifiers/regulator_devices_change_notifier.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../popup_menu_item_divider.dart';

class RegulatorDeviceListTileMenu extends StatelessWidget {
  final BuildContext context;
  final RegulatorDeviceModel device;

  const RegulatorDeviceListTileMenu({super.key, required this.context, required this.device});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegulatorDevicesChangeNotifier>(
      builder: (context, value, child) => PopupMenuButton(
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
            const PopupMenuItemDivider(),
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
            const PopupMenuItemDivider(),
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
            const PopupMenuItemDivider(),
            PopupMenuItem(
              child: const Row(children: [
                Icon(Icons.install_desktop_outlined),
                SizedBox(
                  width: 10,
                ),
                Text(AppStrings.menuDeploy)
              ]),
              onTap: () async {
                await _showDeployDialog();
              },
            ),
          ];
        },
      ),
    );
  }

  Future<void> _showDeployDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeploymentDialog(
            context: context,
            titleText: AppStrings.dialogTitleDeploy,
          );
        });
  }

  Future<void> _showDeleteRegulatorDevice() async {
    var dialogResult = await showDialog<DialogResult>(
        context: context,
        builder: (BuildContext context) {
          return AppBaseDialog(
            titleText: AppStrings.dialogTitleConfirm,
            context: context,
            actions: [
              AppElevatedButton(
                  onPressed: () async {
                    Navigator.pop<DialogResult>(
                        context, DialogResult<RegulatorDeviceModel?>(result: ModalResults.ok, value: device));
                  },
                  child: const Text(AppStrings.buttonOk)),
              AppElevatedButton(
                  onPressed: () {
                    Navigator.pop<DialogResult>(
                        context, DialogResult<RegulatorDeviceModel?>(result: ModalResults.cancel));
                  },
                  child: const Text(AppStrings.buttonCancel))
            ],
            content: const SizedBox(width: 480, child: Text(AppStrings.confirmRemoveDevice)),
          );
        });

    if (dialogResult?.result == ModalResults.ok && dialogResult?.value != null) {
      var updatedDevice = await Provider.of<RegulatorDevicesChangeNotifier>(context, listen: false).delete(device);
      if (updatedDevice != null) {
        AppToast.show(context, ToastTypes.success, 'The device ${device.name} successfully removed.');
      } else {
        AppToast.show(context, ToastTypes.error, 'The device deleting was failed.');
      }
    }
  }

  Future<void> _showAccessTokenDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
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

    if (dialogResult?.result == ModalResults.ok) {
      var updatedDevice = await Provider.of<RegulatorDevicesChangeNotifier>(context, listen: false).put(device);
      if (updatedDevice != null) {
        AppToast.show(context, ToastTypes.success, 'The device ${device.name} successfully updated.');
      } else {
        AppToast.show(context, ToastTypes.error, 'The device updating was failed.');
      }
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
        file.writeAsBytes(imageData.buffer.asUint8List()).then((value) {
          AppToast.show(context, ToastTypes.success, 'QR-code with device ID saved successfully.');
        });
      }
    }
  }
}
