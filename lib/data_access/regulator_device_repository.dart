import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/foundation.dart';

import 'app_repository.dart';

class RegulatorDeviceRepository {
  static const String endPoint = '/regulator-devices';
  final Dio httpClient = getIt<AppHttpClientFactory>().httpClient;

  Future<List<RegulatorDeviceModel>?> getList() async {
    List<RegulatorDeviceModel>? devices = List.empty(growable: true);

    try {
      var response = await httpClient.get('${RegulatorDeviceRepository.endPoint}/');
      if (response.statusCode == 200) {
        var devicesMapList = response.data;
        devices = List<RegulatorDeviceModel>.from(devicesMapList.map((e) => RegulatorDeviceModel.fromJson(e)));
      }
    } on Exception catch (e) {
      devices = null;
      debugPrint('Exception details:\n $e');
    }

    return devices;
  }

  Future<RegulatorDeviceModel?> put(RegulatorDeviceModel device) async {
    RegulatorDeviceModel? updatedDevice;

    try {
      var response = await httpClient.put('${RegulatorDeviceRepository.endPoint}/', data: device.toJson());
      if (response.statusCode == 200) {
        updatedDevice = RegulatorDeviceModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Exception details:\n $e');
    }

    return updatedDevice;
  }

  Future<RegulatorDeviceModel?> post(RegulatorDeviceModel device) async {
    RegulatorDeviceModel? updatedDevice;

    try {
      var response = await httpClient.post('${RegulatorDeviceRepository.endPoint}/', data: device.toJson());
      if (response.statusCode == 200) {
        updatedDevice = RegulatorDeviceModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Exception details:\n $e');
    }

    return updatedDevice;
  }

  Future<RegulatorDeviceModel?> delete(RegulatorDeviceModel device) async {
    RegulatorDeviceModel? updatedDevice;

    try {
      var response = await httpClient.delete('${RegulatorDeviceRepository.endPoint}/${device.id}');
      if (response.statusCode == 200) {
        updatedDevice = RegulatorDeviceModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Exception details:\n $e');
    }

    return updatedDevice;
  }
}
