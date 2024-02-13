import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/app_title_bar.dart';
import 'package:flutter_test_app/components/app_drawer/app_drawer.dart';
import 'package:flutter_test_app/components/regulator_device_list/regulator_device_list.dart';
import 'package:flutter_test_app/constants/app_strings.dart';
import 'package:flutter_test_app/data_access/regulator_device_repository.dart';
import 'package:flutter_test_app/dialogs/regulator_device_dialog/regulator_device_dialog.dart';
import 'package:flutter_test_app/models/dialog_result.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<RegulatorDeviceModel> _devices = List.empty(growable: true);

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

  @override
  void initState() {
    _devices = RegulatorDeviceRepository(context).getList();

    super.initState();
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
                              var dialogResult = await showDialog<DialogResult>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return RegulatorDeviceDialog(
                                      context: context,
                                      titleText: AppStrings.dialogTitleEditDevice,
                                      device: null,
                                    );
                                  });

                                  if (dialogResult!.result == ModalResults.ok) {

                                  }
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
}
