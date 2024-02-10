import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

// ignore: must_be_immutable
class AccessTokenDialog extends AppBaseDialog {
  late TextEditingController? _accessTokenEditingController;
  final RegulatorDeviceModel device;

  AccessTokenDialog({super.key, required super.context, required super.titleText, required this.device}) : super() {
    _accessTokenEditingController = TextEditingController(text: device.name);
  }

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          icon: const Icon(Icons.close),
        )
      ];

  @override
  Widget get content => SizedBox(
      width: 420,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: _accessTokenEditingController,
          decoration: InputDecoration(
            hintText: 'Access token',
            suffixIcon: IconButton(
              onPressed: () {
                _accessTokenEditingController!.clear();
              },
              icon: const Icon(Icons.key),
            ),
          ),
        ),
      ]));
}
