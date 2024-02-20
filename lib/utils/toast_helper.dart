import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastTypes { success, info, error, warning }

class AppToast {
  static void show(BuildContext context, ToastTypes type, String text,
      {Duration duration = const Duration(seconds: 2)}) {
    FToast().init(context).showToast(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: type == ToastTypes.success
                    ? Colors.green[500]
                    : (type == ToastTypes.error
                        ? Colors.red[500]
                        : (type == ToastTypes.warning ? Colors.yellow[500] : Colors.blue[300])),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Text(
                    text,
                  )
                ],
              )),
          toastDuration: duration,
          gravity: ToastGravity.BOTTOM,
        );
  }
}
