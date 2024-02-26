import 'package:flutter/material.dart';

class PopupMenuItemDivider extends PopupMenuItem {
  const PopupMenuItemDivider({super.key, super.child});

  @override
  double get height => 1;

  @override
  Widget? get child => const Divider(
        height: 1,
        thickness: 1,
      );
}
