import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/components/editors/spin_text_field.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/access_token_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class AccessTokenDialog extends AppBaseDialog {
  late TextEditingController? _accessTokenEditingController;
  late TextEditingController? _durationPeriodEditingController;
  final RegulatorDeviceModel device;

  AccessTokenDialog(
      {super.key,
      required super.context,
      required super.titleText,
      super.titleIcon = Icons.key_outlined,
      required this.device})
      : super() {
    _accessTokenEditingController = TextEditingController(text: '');
    _durationPeriodEditingController = TextEditingController(text: '8');
  }

  @override
  List<Widget> get actions => [
        AppElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonOk,
              icon: Icons.check,
            )),
        AppElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonClose,
              icon: Icons.close,
            )),
      ];

  @override
  Widget get content => SizedBox(
      width: 640,
      child: Wrap(runSpacing: 20, children: [
        SpinTextField(controller: _durationPeriodEditingController, min: 1, max: 12, labelText: 'Duration period'),
        TextField(
          controller: _accessTokenEditingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Access token',
            suffixIcon: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await _getAccessToken();
                    },
                    icon: const Icon(Icons.key),
                  ),
                  IconButton(
                    onPressed: () {
                      copyToClipboard();
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
          ),
        ),
      ]));

  void copyToClipboard() {
    if (_accessTokenEditingController!.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _accessTokenEditingController!.text)).then((_) {
        AppToast.show(context, ToastTypes.success, 'New access token copied', duration: const Duration(seconds: 2));
      });
    }
  }

  Future<void> _getAccessToken() async {
    var repository = AccessTokenRepository();
    int duration = int.parse(_durationPeriodEditingController!.text);
    var accessToken = await repository.get(device, duration);
    if (accessToken != null) {
      _accessTokenEditingController!.text = accessToken.token;
    }
  }
}
