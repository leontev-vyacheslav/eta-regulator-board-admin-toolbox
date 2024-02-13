import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/app_title_bar.dart';
import 'package:flutter_test_app/components/app_drawer/app_drawer.dart';
import 'package:flutter_test_app/components/regulator_device_list/regulator_device_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(scaffoldKey: _scaffoldKey, context: context),
      body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [AppTitleBar(scaffoldKey: _scaffoldKey), const RegulatorDeviceList()],
          )),
    );
  }
}
