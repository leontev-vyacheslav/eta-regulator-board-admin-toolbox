import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/foundation.dart';

class RegulatorDevicesChangeNotifier extends ChangeNotifier {
  final List<RegulatorDeviceModel> _items = [];

  RegulatorDevicesChangeNotifier() {
    var repository = RegulatorDeviceRepository();
    repository.getList().then((devices) {
      if (devices != null) {
        _items.addAll(devices);
        notifyListeners();
      }
    });
  }

  List<RegulatorDeviceModel> get items => _items;

  Future<List<RegulatorDeviceModel>?> refresh() async {
    var repository = RegulatorDeviceRepository();
    var devices = await repository.getList();
    if (devices != null) {
      _items.clear();
      _items.addAll(devices);
      notifyListeners();
    }

    return devices;
  }

  Future<RegulatorDeviceModel?> post(RegulatorDeviceModel device) async {
    var repository = RegulatorDeviceRepository();
    var updatedDevice = await repository.post(device);
    if (updatedDevice != null) {
      _items.add(device);
      notifyListeners();
    }

    return updatedDevice;
  }

  Future<RegulatorDeviceModel?> delete(RegulatorDeviceModel device) async {
    var repository = RegulatorDeviceRepository();
    var updatedDevice = await repository.delete(device);
    if (updatedDevice != null) {
      _items.removeWhere((d) => d.id == device.id);
      notifyListeners();
    }

    return updatedDevice;
  }

  Future<RegulatorDeviceModel?> put(RegulatorDeviceModel device) async {
    var repository = RegulatorDeviceRepository();
    var updatedDevice = await repository.put(device);
    if (updatedDevice != null) {
      _items.removeWhere((d) => d.id == device.id);
      _items.add(device);
      notifyListeners();
    }

    return updatedDevice;
  }
}
