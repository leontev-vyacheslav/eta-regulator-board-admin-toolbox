import 'package:flutter/material.dart';

class AppElevatedButton extends ElevatedButton {
  const AppElevatedButton({super.key, required super.onPressed, required super.child});

  @override
  ButtonStyle? get style => ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
      );
}
