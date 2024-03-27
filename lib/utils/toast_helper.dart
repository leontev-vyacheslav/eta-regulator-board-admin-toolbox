import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastTypes { success, info, error, warning }

class AppToast {
  static List<Color?> toastColors = [Colors.green[500], Colors.blue[300], Colors.red[500], Colors.orange[800]];
  static List<IconData> icons = [Icons.check, Icons.info, Icons.error, Icons.warning];

  static void show(BuildContext context, ToastTypes type, String text,
      {Duration duration = const Duration(seconds: 3)}) {
    FToast().init(context).showToast(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5.0), color: AppToast.toastColors[type.index]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(AppToast.icons[type.index]),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                      child: Text(
                    overflow: TextOverflow.visible,
                    text,
                  ))
                ],
              )),
          toastDuration: duration,
          gravity: ToastGravity.BOTTOM,
        );
  }
}
