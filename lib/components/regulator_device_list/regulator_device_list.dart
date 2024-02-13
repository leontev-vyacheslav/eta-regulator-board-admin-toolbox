import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

class RegulatorDeviceList extends StatefulWidget {
  final List<RegulatorDeviceModel> devices;
  final UpdateCallbackFunction? updateCallback;

  const RegulatorDeviceList({super.key, required this.devices, this.updateCallback});

  @override
  State<StatefulWidget> createState() => _RegulatorDeviceListState();
}

class _RegulatorDeviceListState extends State<RegulatorDeviceList> {
  List<ListTile> _getListItems(BuildContext context) {
    return widget.devices
        .map((device) => RegulatorDeviceListTile(
              context: context,
              device: device,
              updateCallback: widget.updateCallback,
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
