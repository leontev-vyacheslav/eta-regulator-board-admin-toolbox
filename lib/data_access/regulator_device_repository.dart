import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegulatorDeviceRepository {
  final BuildContext context;

  RegulatorDeviceRepository(this.context);

  Future<List<RegulatorDeviceModel>> getList() async {
    List<RegulatorDeviceModel> devices = List.empty(growable: true);

    var httpClient = HttpClient();
    var host = 'eta.ru';
    var port = 15020;

    if (kDebugMode) {
      port = 5020;
      if (PlatformInfo.isDesktopOS) {
        host = 'localhost';
      } else if (Platform.isAndroid) {
        host = '10.0.2.2';
      }
    }
    try {
      var request = await httpClient.get(host, port, '/regulator-devices');
      var response = await request.close();
      if (response.statusCode == 200) {
        var json = await response.transform(utf8.decoder).join();
        List<dynamic> devicesMapList = jsonDecode(json);
        devices = devicesMapList.map((e) => RegulatorDeviceModel.fromJson(e)).toList();
      }
    } finally {
      httpClient.close();
    }

    return devices;
  }

  Future<void> _save(List<RegulatorDeviceModel> devices) async {
    var jsonText = jsonEncode(devices);

    await App.of(context).localStorage.setString('devices', jsonText);
  }

  Future<void> update(RegulatorDeviceModel device) async {
    var devices = await getList();
    devices.removeWhere((e) => e.id == device.id);
    devices.add(device);

    await _save(devices);
  }

  Future<void> remove(RegulatorDeviceModel device) async {
    var devices = await getList();
    devices.removeWhere((e) => e.id == device.id);

    await _save(devices);
  }
}
