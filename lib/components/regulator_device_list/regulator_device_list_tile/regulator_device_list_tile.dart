import 'package:eta_regulator_board_admin_toolbox/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile_menu.dart';
import 'package:flutter/material.dart';

import '../../../models/regulator_device_model.dart';

class RegulatorDeviceListTile extends ListTile {
  final RegulatorDeviceModel device;
  final BuildContext context;

  const RegulatorDeviceListTile({required this.context, required this.device, super.key});

  @override
  Widget? get leading => const Icon(Icons.devices);

  @override
  Widget? get title => Text(device.name);

  @override
  GestureTapCallback? get onTap => () {
        debugPrint(device.id);
      };

  @override
  VisualDensity? get visualDensity => const VisualDensity(vertical: 2);

  @override
  Widget? get trailing => RegulatorDeviceListTileMenu(device: device, context: context);
}
