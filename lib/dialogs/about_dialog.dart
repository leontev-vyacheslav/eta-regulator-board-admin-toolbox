import 'package:flutter/material.dart';
import 'package:flutter_test_app/dialogs/app_base_dialog.dart';

class AboutDialog extends AppBaseDialog {
  const AboutDialog({super.key, required super.context, required super.titleText});

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: const Text('CLOSE'),
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
        width: 460,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('assets/images/icon.ico'),
            const SizedBox(width: 20),
            const Text(
              'ETA Regulator Board Admin v.0.01',
              style: TextStyle(color: Color.fromRGBO(0xff, 0x57, 0x22, 1)),
            )
          ],
        ),
      );
}
