import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants/app_colors.dart';
import 'package:flutter_test_app/constants/app_strings.dart';
import 'package:flutter_test_app/data_access/regulator_device_repository.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';
import 'package:flutter_test_app/models/regulator_device_model.dart';

import 'regulator_device_dialog_form.dart';

class RegulatorDeviceDialog extends AppBaseDialog {
  final RegulatorDeviceModel? device;
  final _formKey = GlobalKey<FormState>();

  RegulatorDeviceDialog({super.key, required super.context, required super.titleText, this.device});

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: Text(device != null ? 'UPDATE' : 'CREATE'),
          onPressed: () async {
            if (_formKey.currentState != null) {
              _formKey.currentState!.save();
            }
            if (device != null) {
              await RegulatorDeviceRepository(context).update(device!);
            }

            if (!context.mounted) {
              return;
            }
            Navigator.popAndPushNamed(
              context,
              '/',
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            minimumSize: const Size(120, 40),
            backgroundColor: AppColors.textAccent,
            foregroundColor: Colors.white,
          ),
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
  Widget? get content => RegulatorDeviceDialogForm(
        key: _formKey,
        device: device,
      );
}
