import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:flutter/material.dart';

class AppBaseDialog extends AlertDialog {
  final BuildContext context;
  final String titleText;
  final IconData? titleIcon;

  const AppBaseDialog(
      {required this.context, required this.titleText, this.titleIcon, super.key, super.actions, super.content});

  @override
  EdgeInsetsGeometry? get titlePadding => const EdgeInsets.fromLTRB(20, 15, 20, 15);

  @override
  EdgeInsets get insetPadding => const EdgeInsets.all(10);

  @override
  get shape => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)));

  @override
  Widget get title => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          titleIcon != null
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(5, 8, 15, 5),
                  child: Icon(
                    titleIcon,
                    size: 26,
                  ),
                )
              : const SizedBox.shrink(),
          Expanded(
              child: Text(
            titleText,
            style: const TextStyle(fontSize: 22),
          )),
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop<DialogResult>(context, DialogResult(result: ModalResults.cancel));
              }),
        ],
      );
}
