import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/constants/app_paths.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static String fileName = 'devices.json';

  static Future<bool> downloadDevices() async {
    String? outputFile;
    if (PlatformInfo.isDesktopOS()) {
      outputFile = await FilePicker.platform.saveFile(
          dialogTitle: AppStrings.dialogTitleSaveFilePicker, fileName: FileHelper.fileName, allowedExtensions: ['json']);
    } else if (!kIsWeb && Platform.isAndroid) {
      var directory = Directory(AppPaths.androidDownloadFolder);
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

      return true;
    }

    return false;
  }
}
