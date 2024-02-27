import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                    ];
                  },
                ),
              ],
            ),
            SizedBox(
              width: 640,
              height: 200,
              child: TextField(
                readOnly: true,
                decoration: const InputDecoration(fillColor: Colors.black, filled: true),
                style: const TextStyle(fontFamily: 'Consolas', fontSize: 14, backgroundColor: Colors.black),
                controller: _textEditingController!,
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

  Future<void> _checkConnection() async {
    _textEditingController?.text = '';
    var scriptPath = kDebugMode ? 'assets/' : 'data/flutter_assets/assets/';

    var process = await Process.start(
      'pwsh.exe',
      ['${scriptPath}check_connection.ps1', '-ipaddr', _device!.name],
    );

    process.stdout.transform(utf8.decoder).listen((data) {
      _textEditingController?.text += data;
    });
  }
}
