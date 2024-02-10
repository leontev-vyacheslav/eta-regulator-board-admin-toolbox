import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_app/app.dart';
import 'package:flutter_test_app/components/regulator_device_list_tile.dart';
import 'package:flutter_test_app/components/app_title_bar.dart';
import 'package:flutter_test_app/components/app_drawer.dart';

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
    String? jsonText = App.localStorage?.getString('devices');

    if (jsonText != null) {
      List<dynamic> devicesMapList = jsonDecode(jsonText);

      List<RegulatorDeviceModel> devices = devicesMapList.map((e) => RegulatorDeviceModel.fromJson(e)).toList();

      return devices
          .map((device) => RegulatorDeviceListTile(
                context: context,
                device: device,
              ))
          .toList();
    }

    return List.empty();
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
