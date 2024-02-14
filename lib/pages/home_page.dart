import 'package:eta_regulator_board_admin_toolbox/components/app_drawer/app_drawer.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_title_bar.dart';
import 'package:eta_regulator_board_admin_toolbox/components/regulator_device_list/regulator_device_list.dart';
import 'package:eta_regulator_board_admin_toolbox/components/regulator_device_list/regulator_device_list_tile/regulator_device_list_tile.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/regulator_device_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<RegulatorDeviceModel> _devices = List.empty(growable: true);

  void update({RegulatorDeviceModel? device, required UpdateCallbackOperations operation}) async {
    var repository = RegulatorDeviceRepository(context);

    if (device != null) {
      if (operation == UpdateCallbackOperations.create || operation == UpdateCallbackOperations.update) {
        await repository.update(device);
      } else if (operation == UpdateCallbackOperations.remove) {
        await repository.remove(device);
      }
    }

    setState(() {
      _devices = repository.getList();
    });
  }

  @override
  void initState() {
    _devices = RegulatorDeviceRepository(context).getList();
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(scaffoldKey: _scaffoldKey, context: context),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              AppTitleBar(scaffoldKey: _scaffoldKey),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
                child: Row(
                  children: [
                    const Expanded(
                        child: Text(
                      'Regulator device list',
                    )),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            onTap: () async {
                              update(operation: UpdateCallbackOperations.refresh);
                            },
                            child: const Row(children: [
                              Icon(Icons.refresh_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(AppStrings.menuRefresh)
                            ]),
                          ),
                          PopupMenuItem(
                              onTap: () {},
                              height: 1,
                              child: const Divider(
                                height: 1,
                                thickness: 1,
                              )),
                          PopupMenuItem(
                            onTap: () async {
                              await _showCreateRegulatorDialog();
                            },
                            child: const Row(children: [
                              Icon(Icons.add),
                              SizedBox(
                                width: 10,
                              ),
                              Text(AppStrings.menuAddDevice)
                            ]),
                          ),
                        ];
                      },
                    )
                  ],
                ),
              ),
              RegulatorDeviceList(
                devices: _devices,
                updateCallback: update,
              )
            ],
          )),
    );
  }

  Future<void> _showCreateRegulatorDialog() async {
    var dialogResult = await showDialog<DialogResult<RegulatorDeviceModel?>>(
        context: context,
        builder: (BuildContext context) {
          return RegulatorDeviceDialog(
            context: context,
            titleText: AppStrings.dialogTitleEditDevice,
            device: RegulatorDeviceModel(id: '', name: 'Omega-XXXX', macAddress: '00:00:00:00:00:00', masterKey: ''),
          );
        });

    if (dialogResult!.result == ModalResults.ok && dialogResult.value != null) {
      update(device: dialogResult.value, operation: UpdateCallbackOperations.create);
    }
  }
}
