import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile.dart';
import 'package:flutter_test_app/data_access/regulator_device_repository.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

class RegulatorDeviceList extends StatefulWidget {
  const RegulatorDeviceList({super.key});

  @override
  State<StatefulWidget> createState() => _RegulatorDeviceListState();
}

class _RegulatorDeviceListState extends State<RegulatorDeviceList> {
  List<RegulatorDeviceModel> _devices = List.empty(growable: true);

  @override
  void initState() {
    _devices = RegulatorDeviceRepository(context).getList();

    super.initState();
  }

  void update(RegulatorDeviceModel? device) async {
    var repository = RegulatorDeviceRepository(context);
    if (device != null) {
      await repository.update(device);
    }

    setState(() {
      if (device != null) {
        _devices = repository.getList();
      }
    });
  }

  List<ListTile> _getListItems(BuildContext context) {
    return _devices
        .map((device) => RegulatorDeviceListTile(
              context: context,
              device: device,
              updateCallback: update,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: _getListItems(context),
    ));
  }
}
