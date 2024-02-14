import 'package:flutter/material.dart';

class AppBaseDialog extends AlertDialog {
  final BuildContext context;
  final String titleText;

  const AppBaseDialog({required this.context, required this.titleText, super.key, super.actions, super.content});

  @override
  EdgeInsetsGeometry? get titlePadding => const EdgeInsets.fromLTRB(20, 15, 20, 15);

  @override
  EdgeInsets get insetPadding => const EdgeInsets.all(10);

  @override
  get shape => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  Widget get title => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Text(
            titleText,
            style: const TextStyle(fontSize: 22),
          )),
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );
}
