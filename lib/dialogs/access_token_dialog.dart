import 'dart:convert';
import 'dart:io';

import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/access_token_model.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccessTokenDialog extends AppBaseDialog {
  late TextEditingController? _accessTokenEditingController;
  final RegulatorDeviceModel device;

  AccessTokenDialog({super.key, required super.context, required super.titleText, required this.device}) : super() {
    _accessTokenEditingController = TextEditingController(text: '');
  }

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: const Text(AppStrings.buttonOk),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              minimumSize: const Size(120, 40)),
          icon: const Icon(Icons.check),
        ),
        ElevatedButton.icon(
          label: const Text(AppStrings.buttonCancel),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              minimumSize: const Size(120, 40)),
          icon: const Icon(Icons.close),
        )
      ];

  @override
  Widget get content => SizedBox(
      width: 640,
      child: Wrap(runSpacing: 20, children: [
        TextField(
          controller: _accessTokenEditingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Access token',
            suffixIcon: IconButton(
              onPressed: () async {
                var httpClient = HttpClient();
                try {
                  var host = 'eta.ru';
                  var port = 15020;

                  if (kDebugMode) {
                    port = 5020;
                    if (PlatformInfo.isDesktopOS) {
                      host = 'localhost';
                    } else if (Platform.isAndroid) {
                      host = '10.0.2.2';
                    }
                  }
                  var request = await httpClient.get(host, port, '/access-token?device_id=${device.id}');
                  var response = await request.close();
                  if (response.statusCode == 200) {
                    var json = await response.transform(utf8.decoder).join();
                    var accessTokenMap = jsonDecode(json);
                    var accessToken = AccessTokenModel.fromJson(accessTokenMap);
                    _accessTokenEditingController!.text = accessToken.token;
                  }
                } finally {
                  httpClient.close();
                }
              },
              icon: const Icon(Icons.key),
            ),
          ),
        ),
      ]));
}
