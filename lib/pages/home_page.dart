import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/regulator_device_list_tile.dart';
import 'package:flutter_test_app/components/window_title_bar.dart';
import 'package:flutter_test_app/components/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ListTile> _getItems() {
    List<String> names = List.from(['Omega-7891', 'Omega-8f79']);

    return names
        .map((name) => RegulatorDeviceListTile(
              name: name,
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
              WindowTitleBar(scaffoldKey: _scaffoldKey),
              Expanded(
                  child: ListView(
                children: _getItems(),
              )),
            ],
          )),
    );
  }
}
