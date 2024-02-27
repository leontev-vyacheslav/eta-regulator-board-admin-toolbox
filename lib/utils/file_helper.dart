import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static String fileName = 'devices.json';

  static Future<void> downloadDevices() async {
    String? outputFile;
    if (PlatformInfo.isDesktopOS) {
      outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Please select an output file:', fileName: FileHelper.fileName, allowedExtensions: ['json']);
    } else if (Platform.isAndroid) {
      var directory = Directory("/storage/emulated/0/Download");
      outputFile = '${directory.path}/${FileHelper.fileName}';
    } else {
      var directory = await getApplicationDocumentsDirectory();
      outputFile = '${directory.path}/${FileHelper.fileName}';
    }

    var devices = await RegulatorDeviceRepository().getList();
    var jsonDevices = jsonEncode(devices);

    if (outputFile != null) {
      var file = File(outputFile);
      await file.writeAsString(jsonDevices);
    }
  }

  // Future<void> uploadDevices() async {
  //   var pickerResult = await FilePicker.platform.pickFiles(
  //       dialogTitle: 'Please select a file:', allowedExtensions: ['json'], allowMultiple: false, type: FileType.custom);

  //   if (pickerResult != null && pickerResult.files.isNotEmpty) {
  //     var file = File(pickerResult.files[0].path!);

  //     var jsonDevices = await file.readAsString();

  //     if (context.mounted) {
  //       await App.of(context).localStorage.setString('devices', jsonDevices);
  //       // ignore: use_build_context_synchronously
  //       await Navigator.popAndPushNamed(context, '/');
  //     }
  //   }
  // }
}
