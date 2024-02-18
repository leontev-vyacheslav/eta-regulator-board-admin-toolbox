
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/access_token_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
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
                var repository = AccessTokenRepository();
                var accessToken = await repository.get(device);
                if (accessToken != null) {
                  _accessTokenEditingController!.text = accessToken.token;
                }
              },
              icon: const Icon(Icons.key),
            ),
          ),
        ),
      ]));
}
