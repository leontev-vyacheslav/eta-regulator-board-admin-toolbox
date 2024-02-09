import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowDragArea extends StatelessWidget {
  final Widget child;
  final bool maximizable;

  const WindowDragArea(
      {super.key, required this.child, required this.maximizable});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        windowManager.startDragging();
      },
      onDoubleTap: maximizable
          ? () async {
              bool isMaximized = await windowManager.isMaximized();
              if (!isMaximized) {
                windowManager.maximize();
              } else {
                windowManager.unmaximize();
              }
            }
          : null,
      child: child,
    );
  }
}