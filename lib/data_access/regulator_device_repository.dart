import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_app/app.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

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

  Future<void> update(RegulatorDeviceModel device) async {
    var devices = getList();
    devices.removeWhere((e) => e.id == device.id);
    devices.add(device);

    String jsonText = jsonEncode(devices);

    await App.of(context).localStorage.setString('devices', jsonText);
  }
}
