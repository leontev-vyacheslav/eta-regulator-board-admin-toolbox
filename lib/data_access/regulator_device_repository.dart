import 'dart:convert';

import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/material.dart';

class RegulatorDeviceRepository {
  final BuildContext context;

  RegulatorDeviceRepository(this.context);

  List<RegulatorDeviceModel> getList() {
    var jsonText = App.of(context).localStorage.getString('devices');

    if (jsonText != null) {
      List<dynamic> devicesMapList = jsonDecode(jsonText);

      List<RegulatorDeviceModel> devices = devicesMapList.map((e) => RegulatorDeviceModel.fromJson(e)).toList();

      return devices;
    }

    return List.empty();
  }

  Future<void> _save(List<RegulatorDeviceModel> devices) async {
    var jsonText = jsonEncode(devices);

    await App.of(context).localStorage.setString('devices', jsonText);
  }

  Future<void> update(RegulatorDeviceModel device) async {
    var devices = getList();
    devices.removeWhere((e) => e.id == device.id);
    devices.add(device);

    await _save(devices);
  }
}
