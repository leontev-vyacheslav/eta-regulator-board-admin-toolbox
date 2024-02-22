import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/foundation.dart';

import 'app_repository.dart';

class RegulatorDeviceRepository extends AppRepository {
  static const String endPoint = '/regulator-devices';

  Future<List<RegulatorDeviceModel>?> getList() async {
    List<RegulatorDeviceModel>? devices = List.empty(growable: true);

    var httpClient = await getHttpClient();

    try {
      var response = await httpClient.get('${RegulatorDeviceRepository.endPoint}/');
      if (response.statusCode == 200) {
        var devicesMapList = response.data;
        devices = List<RegulatorDeviceModel>.from(devicesMapList.map((e) => RegulatorDeviceModel.fromJson(e)));
      }
    } on Exception catch (e) {
      devices = null;
      debugPrint('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return devices;
  }

  Future<RegulatorDeviceModel?> put(RegulatorDeviceModel device) async {
    var httpClient = await getHttpClient();
    RegulatorDeviceModel? updatedDevice;

    try {
      var response = await httpClient.put('${RegulatorDeviceRepository.endPoint}/', data: device.toJson());
      if (response.statusCode == 200) {
        updatedDevice = RegulatorDeviceModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return updatedDevice;
  }

  Future<RegulatorDeviceModel?> post(RegulatorDeviceModel device) async {
    var httpClient = await getHttpClient();
    RegulatorDeviceModel? updatedDevice;

    try {
      var response = await httpClient.post('${RegulatorDeviceRepository.endPoint}/', data: device.toJson());
      if (response.statusCode == 200) {
        updatedDevice = RegulatorDeviceModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return updatedDevice;
  }

  Future<RegulatorDeviceModel?> delete(RegulatorDeviceModel device) async {
    var httpClient = await getHttpClient();
    RegulatorDeviceModel? updatedDevice;

    try {
      var response = await httpClient.delete('${RegulatorDeviceRepository.endPoint}/${device.id}');
      if (response.statusCode == 200) {
        updatedDevice = RegulatorDeviceModel.fromJson(response.data);
      }
    } catch (e) {
      debugPrint('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return updatedDevice;
  }
}
