import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/components/popup_menu_item_divider.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:core';
import 'package:collection/collection.dart';

class DeploymentDialogForm extends StatefulWidget {
  final RegulatorDeviceModel device;
  final BuildContext context;

  const DeploymentDialogForm({
    super.key,
    required this.context,
    required this.device,
  });

  @override
  State<StatefulWidget> createState() => _DeploymentDialogFormState();
}

class _DeploymentDialogFormState extends State<DeploymentDialogForm> {
  RegulatorDeviceModel? _device;
  Process? _process;
  bool _menuEnable = true;

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _textFieldScrollController = ScrollController();
  final String _deploymentPath = kDebugMode ? 'assets/deployment' : 'data/flutter_assets/assets/deployment';

  @override
  void initState() {
    _device = widget.device;
    _checkConnection();
    super.initState();
  }

  Widget buildPopupMenu() {
    return Row(
      children: [
        Expanded(
            child: Text(
          'Deployment log of "${_device!.name}" device:',
        )),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _checkConnection();
                },
                child: const Row(children: [
                  Icon(Icons.wifi),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Check connection')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _deploy('web_ui');
                },
                child: const Row(children: [
                  Icon(Icons.web_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Deploy Web UI')
                ]),
              ),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _deploy('web_api');
                },
                child: const Row(children: [
                  Icon(Icons.api_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Deploy Web API')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _deployAll();
                },
                child: const Row(children: [
                  Icon(Icons.install_desktop_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Deploy all')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: !_menuEnable,
                onTap: () {
                  _stopScriptProcess();
                },
                child: const Row(children: [
                  Icon(Icons.back_hand_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Stop deployment')
                ]),
              )
            ];
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            buildPopupMenu(),
            SizedBox(
              width: 640,
              height: 200,
              child: TextField(
                decoration: InputDecoration(fillColor: Theme.of(widget.context).primaryColor, filled: true),
                style: TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 14,
                    backgroundColor: Theme.of(widget.context).primaryColor,
                    color: Colors.white70),
                controller: _textEditingController,
                scrollController: _textFieldScrollController,
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _stdStreamListener(String text) {
    text = text.replaceAll(RegExp('\x1b[[0-9;]*m'), '');
    _textEditingController.text += text;
    _textFieldScrollController.jumpTo(_textFieldScrollController.position.maxScrollExtent);
  }

  Map<String, Object> _getLastDistributable(String appName) {
    var distributableDir = Directory('$_deploymentPath/distributable');
    var distroFolderInfo = distributableDir
        .listSync()
        .where((d) => d.path.startsWith('eta_regulator_board_$appName'))
        .map((d) {
          var folderName = basenameWithoutExtension(d.path);
          return {'name': folderName, 'date': DateTime.parse(folderName.split('_').last)};
        })
        .sortedBy((element) => element.keys.first)
        .last;

    return distroFolderInfo;
  }

  void _stopScriptProcess() {
    if (_process != null) {
      _process!.kill();
      _process = null;
    }
  }

  Future<void> _startScriptProcess(List<String> args, {bool clearLog = true}) async {
    if (_process != null) {
      _process!.kill();
      _process = null;
    }

    if (clearLog) {
      _textEditingController.text = '';
    }

    setState(() {
      _menuEnable = false;
    });

    _process = await Process.start(
      'pwsh.exe',
      args,
    );

    _process!.stdout.transform(utf8.decoder).listen(_stdStreamListener);
    _process!.stderr.transform(utf8.decoder).listen(_stdStreamListener);

    _process!.exitCode.then((value) {
      setState(() {
        _menuEnable = true;
      });
    });
  }

  Future<void> _checkConnection() async {
    await _startScriptProcess(['$_deploymentPath/check_connection.ps1', '-ipaddr', _device!.name]);
  }

  Future<void> _deploy(String appName, {bool clearLog = true}) async {
    var distroFolder = _getLastDistributable(appName);

    _startScriptProcess([
      '$_deploymentPath/deploy_$appName.ps1',
      '-ipaddr',
      _device!.name,
      '-root',
      _deploymentPath,
      '-distro',
      distroFolder.entries.first.value as String,
    ], clearLog: clearLog);
  }

  Future<void> _deployAll() async {
    await _deploy('web_ui', clearLog: false);
    await _deploy('web_api', clearLog: false);
  }
}
