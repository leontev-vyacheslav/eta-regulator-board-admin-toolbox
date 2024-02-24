import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpinTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final int min;
  final int max;

  const SpinTextField({super.key, required this.controller, this.labelText, required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        readOnly: true,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          suffixIcon: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    var num = int.parse(controller!.text);

                    if (num < max) {
                      controller?.text = (int.parse(controller!.text) + 1).toString();
                    }
                  },
                  icon: const Icon(Icons.arrow_drop_up),
                ),
                IconButton(
                  onPressed: () {
                    var num = int.parse(controller!.text);
                    if (num > min) {
                      controller?.text = (int.parse(controller!.text) - 1).toString();
                    }
                  },
                  icon: const Icon(Icons.arrow_drop_down),
                )
              ],
            ),
          ),
        ));
  }
}
