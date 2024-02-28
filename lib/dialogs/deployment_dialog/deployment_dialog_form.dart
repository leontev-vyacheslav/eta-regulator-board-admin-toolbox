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

  const DeploymentDialogForm({
    super.key,
    required this.device,
  });

  @override
  State<StatefulWidget> createState() => _DeploymentDialogFormState();
}

class _DeploymentDialogFormState extends State<DeploymentDialogForm> {
  RegulatorDeviceModel? _device;
  TextEditingController? _textEditingController;
  ScrollController textFieldScrollController = ScrollController();
  List<String> deployments = [];
  Process? _process;
  UniqueKey _menuKey = UniqueKey();

  @override
  void initState() {
    _device = widget.device;
    _textEditingController = TextEditingController();

    _checkConnection();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                    child: Text(
                  'Deployment log',
                )),
                PopupMenuButton(
                  key: _menuKey,
                  enabled: false,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
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
                        onTap: () async {
                          await _deploy();
                        },
                        child: Row(children: [
                          const Icon(Icons.archive_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('Deploy to ${_device?.name}')
                        ]),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SizedBox(
              width: 640,
              height: 200,
              child: TextField(
                decoration: const InputDecoration(fillColor: Colors.black, filled: true),
                style: const TextStyle(
                  fontFamily: 'Consolas',
                  fontSize: 14,
                  backgroundColor: Colors.black,
                ),
                controller: _textEditingController!,
                scrollController: textFieldScrollController,
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  textFieldScrollController.jumpTo(textFieldScrollController.position.maxScrollExtent);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkConnection() async {
    if (_process != null) {
      _process!.kill();
    }

    _textEditingController?.text = '';
    var assetsPath = kDebugMode ? 'assets' : 'data/flutter_assets/assets';

    _process = await Process.start(
      'pwsh.exe',
      ['$assetsPath/deployment/check_connection.ps1', '-ipaddr', _device!.name],
    );

    _process!.stdout.transform(utf8.decoder).listen((data) {
      _textEditingController?.text += data;
    });
    _process!.stderr.transform(utf8.decoder).listen((data) {
      _textEditingController?.text += data;
    });
  }

  Future<void> _deploy() async {
    if (_process != null) {
      _process!.kill();
    }

    _textEditingController?.text = '';
    var assetsPath = kDebugMode ? 'assets' : 'data/flutter_assets/assets';

    var distributableDir = Directory('$assetsPath/deployment/distributable');

    var distroFolder = distributableDir
        .listSync()
        .map((d) {
          var folderName = basenameWithoutExtension(d.path);
          return {'name': folderName, 'date': DateTime.parse(folderName.split('_').last)};
        })
        .sortedBy((element) => element.keys.first)
        .last;

    _process = await Process.start(
      'pwsh.exe',
      [
        '$assetsPath/deployment/deploy.ps1',
        '-ipaddr',
        _device!.name,
        '-root',
        '$assetsPath/deployment',
        '-distro',
        distroFolder.entries.first.value as String,
      ],
    );
    _process!.stdout.transform(utf8.decoder).listen((data) {
      _textEditingController?.text += data;
    });

    _process!.stderr.transform(utf8.decoder).listen((data) {
      _textEditingController?.text += data;
    });
  }
}
