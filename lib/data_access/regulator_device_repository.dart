import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';

import 'app_repository.dart';

class RegulatorDeviceRepository extends AppRepository {
  static const String endPoint = '/regulator-devices';

  Future<List<RegulatorDeviceModel>> getList() async {
    List<RegulatorDeviceModel> devices = List.empty(growable: true);

    var httpClient = await getHttpClient();

    try {
      var response = await httpClient.get('${RegulatorDeviceRepository.endPoint}/');
      if (response.statusCode == 200) {
        var devicesMapList = response.data;
        devices = List<RegulatorDeviceModel>.from(devicesMapList.map((e) => RegulatorDeviceModel.fromJson(e)));
      }
    } on Exception catch (e) {
      devices = List.empty(growable: true);
      // ignore: avoid_print
      print('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return devices;
  }

  Future<void> put(RegulatorDeviceModel device) async {
    var httpClient = await getHttpClient();
    try {
      await httpClient.put('${RegulatorDeviceRepository.endPoint}/', data: device.toJson());
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      httpClient.close(force: true);
    }
  }

  Future<void> post(RegulatorDeviceModel device) async {
    var httpClient = await getHttpClient();

    try {
      await httpClient.post('${RegulatorDeviceRepository.endPoint}/', data: device.toJson());
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      httpClient.close(force: true);
    }
  }

  Future<void> delete(RegulatorDeviceModel device) async {
    var httpClient = await getHttpClient();
    try {
      await httpClient.delete('${RegulatorDeviceRepository.endPoint}/${device.id}');
    } catch (e) {
      // ignore: avoid_print
      print('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }
  }
}
