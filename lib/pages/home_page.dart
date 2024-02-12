
import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/regulator_device_list_tile.dart';
import 'package:flutter_test_app/components/app_title_bar.dart';
import 'package:flutter_test_app/components/app_drawer.dart';
import 'package:flutter_test_app/data_access/regulator_device_repository.dart';

import '../models/regulator_device_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ListTile> _getListItems(BuildContext context) {
    List<RegulatorDeviceModel> devices = RegulatorDeviceRepository(context).getList();

    return devices
        .map((device) => RegulatorDeviceListTile(
              context: context,
              device: device,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(scaffoldKey: _scaffoldKey, context: context),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              AppTitleBar(scaffoldKey: _scaffoldKey),
              Expanded(
                  child: ListView(
                children: _getListItems(context),
              )),
            ],
          )),
    );
  }
}
