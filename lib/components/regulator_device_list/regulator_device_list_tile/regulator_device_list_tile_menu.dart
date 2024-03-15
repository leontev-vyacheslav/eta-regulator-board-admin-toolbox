import 'dart:io';
import 'dart:ui';

import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/access_token_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_exit_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/notifiers/regulator_devices_change_notifier.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../dialogs/deployment_dialog/deployment_dialog.dart';
import '../../popup_menu_item_divider.dart';

class RegulatorDeviceListTileMenu extends StatelessWidget {
  final BuildContext context;
  final RegulatorDeviceModel device;

  const RegulatorDeviceListTileMenu({super.key, required this.context, required this.device});

  @override
  Widget build(BuildContext context) {
    var menuItems = [
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
          await _showRemoveRegulatorDeviceDialog();
        },
      ),
      const PopupMenuItemDivider(),
      PopupMenuItem(
        child: const Row(children: [
          Icon(Icons.qr_code_scanner),
          SizedBox(
            width: 10,
          ),
          Text(AppStrings.menuShowQRCodeId)
        ]),
        onTap: () async {
          await _showWifiDeviceQrCode();
        },
      ),
      PopupMenuItem(
        child: const Row(children: [
          Icon(Icons.qr_code),
          SizedBox(
            width: 10,
          ),
          Text(AppStrings.menuDownloadQRCodeId)
        ]),
        onTap: () async {
          await _saveWifiDeviceQrCode();
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
    ];

    if (PlatformInfo.isDesktopOS()) {
      menuItems.addAll([
        const PopupMenuItemDivider(),
        PopupMenuItem(
          enabled: PlatformInfo.isDesktopOS(),
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
        )
      ]);
    }

    return Consumer<RegulatorDevicesChangeNotifier>(
      builder: (context, value, child) => PopupMenuButton(
        itemBuilder: (context) {
          return menuItems;
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
            device: device,
          );
        });
  }

  Future<void> _showRemoveRegulatorDeviceDialog() async {
    var dialogResult = await showDialog<DialogResult>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RemoveRegulatorDeviceDialog(context: context, device: device);
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

  Future<ByteData?> _getWifiDeviceQrCode() async {
    var painter = QrPainter(
      data: 'WIFI:S:${device.name};T:WPA2;P:12345678;;',
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

    return imageData;
  }

  Future<void> _showWifiDeviceQrCode() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AppBaseDialog(
            context: context,
            titleText: AppStrings.dialogWifiQRCode,
            titleIcon: Icons.qr_code_scanner,
            content: Center(
              heightFactor: 1.1,
              widthFactor: 2,
              child: SizedBox(
                width: 300,
                height: 300,
                child: Column(
                  children: [
                    QrImageView(
                        data: 'WIFI:S:${device.name};T:WPA2;P:12345678;;',
                        size: 250,
                        backgroundColor: Colors.white,
                        version: QrVersions.auto,
                        dataModuleStyle: const QrDataModuleStyle(
                          color: Colors.black,
                          dataModuleShape: QrDataModuleShape.square,
                        ),
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                        semanticsLabel: device.name),
                    Text(
                      device.name,
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              AppElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const AppElevatedButtonLabel(
                    label: AppStrings.buttonClose,
                    icon: Icons.close,
                  )),
            ]);
      },
    );
  }

  Future<void> _saveWifiDeviceQrCode() async {
    var imageData = await _getWifiDeviceQrCode();

    if (imageData != null) {
      String? outputFile;
      if (PlatformInfo.isDesktopOS()) {
        outputFile = await FilePicker.platform.saveFile(
            dialogTitle: 'Please select an output file:', fileName: '${device.name}.png', allowedExtensions: ['*.png']);
      } else if (!kIsWeb && Platform.isAndroid) {
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
