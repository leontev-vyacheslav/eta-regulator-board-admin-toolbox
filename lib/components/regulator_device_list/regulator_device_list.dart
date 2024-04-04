import 'package:eta_regulator_board_admin_toolbox/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/notifiers/regulator_devices_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegulatorDeviceList extends StatefulWidget {
  const RegulatorDeviceList({super.key});

  @override
  State<RegulatorDeviceList> createState() => _RegulatorDeviceListState();
}

class _RegulatorDeviceListState extends State<RegulatorDeviceList> {
  List<ListTile> _getListItems(BuildContext context, List<RegulatorDeviceModel> devices) {
    return devices
        .map((device) => RegulatorDeviceListTile(
              context: context,
              device: device,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var devices = Provider.of<RegulatorDevicesChangeNotifier>(context).items;

    return Expanded(
      child: ListView(children: _getListItems(context, devices)),
    );
  }
}
