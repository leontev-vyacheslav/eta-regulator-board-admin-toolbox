import 'package:flutter/material.dart';

class AppElevatedButton extends ElevatedButton {
  const AppElevatedButton({super.key, required super.onPressed, required super.child});

  @override
  ButtonStyle? get style => ElevatedButton.styleFrom(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.fromLTRB(15, 15, 20, 15));
}

class AppElevatedButtonLabel extends Wrap {
  final String label;
  final IconData? icon;
  final Color? color;

  const AppElevatedButtonLabel({super.key, required this.label, this.icon, this.color});

  @override
  List<Widget> get children => [
        icon != null
            ? Icon(
                icon,
                color: color,
              )
            : const SizedBox.shrink(),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(color: color),
        ),
      ];
}
