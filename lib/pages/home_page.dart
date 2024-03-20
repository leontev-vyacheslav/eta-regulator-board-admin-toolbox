import 'package:eta_regulator_board_admin_toolbox/components/app_drawer/app_drawer.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_title_bar.dart';
import 'package:eta_regulator_board_admin_toolbox/components/regulator_device_list/regulator_device_list.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import '../notifiers/regulator_devices_change_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            toolbarHeight: 60,
            leading: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  _scaffoldKey.currentState!.openDrawer();
                }),
            centerTitle: true,
            title: AppTitleBar(
              context: context,
            )),
        drawer: AppDrawer(scaffoldKey: _scaffoldKey, context: context),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showCreateRegulatorDialog();
          },
          shape: const CircleBorder(),
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          // backgroundColor: Colors.blueAccent,
          // foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        body: Consumer<RegulatorDevicesChangeNotifier>(
          builder: (context, value, child) => const Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Regulator device list',
                        )),
                        // PopupMenuButton(
                        //   icon: const Icon(Icons.menu_open_outlined),
                        //   itemBuilder: (context) {
                        //     return [
                        //       PopupMenuItem(
                        //         onTap: () async {
                        //           var devices =
                        //               await Provider.of<RegulatorDevicesChangeNotifier>(context, listen: false)
                        //                   .refresh();
                        //           if (devices != null) {
                        //             AppToast.show(context, ToastTypes.info, 'The regulator device list was refreshed.');
                        //           } else {
                        //             AppToast.show(
                        //                 context, ToastTypes.error, 'An error was happened during of the  updating.');
                        //           }
                        //         },
                        //         child: const Row(children: [
                        //           Icon(Icons.refresh_outlined),
                        //           SizedBox(
                        //             width: 10,
                        //           ),
                        //           Text(AppStrings.menuRefresh)
                        //         ]),
                        //       ),
                        //       const PopupMenuItemDivider(),
                        //       PopupMenuItem(
                        //         onTap: () async {
                        //           await _showCreateRegulatorDialog();
                        //         },
                        //         child: const Row(children: [
                        //           Icon(Icons.add),
                        //           SizedBox(
                        //             width: 10,
                        //           ),
                        //           Text(AppStrings.menuAddDevice)
                        //         ]),
                        //       ),
                        //     ];
                        //   },
                        // )
                      ],
                    ),
                  ),
                  RegulatorDeviceList()
                ],
              )),
        ));
  }

  Future<void> _showCreateRegulatorDialog() async {
    var dialogResult = await showDialog<DialogResult<RegulatorDeviceModel?>>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RegulatorDeviceDialog(
            context: context,
            titleText: AppStrings.dialogTitleCreateDevice,
            device: RegulatorDeviceModel(
                id: '',
                name: 'Omega-XXXX',
                macAddress: '00:00:00:00:00:00',
                masterKey: '',
                creationDate: DateTime.now().toIso8601String()),
          );
        });

    if (dialogResult!.result == ModalResults.ok && dialogResult.value != null) {
      var updatedDevice =
          await Provider.of<RegulatorDevicesChangeNotifier>(context, listen: false).post(dialogResult.value!);
      if (updatedDevice != null) {
        AppToast.show(context, ToastTypes.success, 'The device ${updatedDevice.name} successfully updated.');
      } else {
        AppToast.show(context, ToastTypes.error, 'The device updating was failed.');
      }
    }
  }
}
