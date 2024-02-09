import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';

class AccessTokenDialog extends AppBaseDialog {
  const AccessTokenDialog({super.key, required super.context, required super.titleText});

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
  Widget get content => const SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Custom Content')],
        ),
      );
}
