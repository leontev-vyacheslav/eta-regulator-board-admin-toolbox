import 'package:flutter/material.dart';
import 'package:flutter_test_app/components/window_drag_area.dart';
import 'package:window_manager/window_manager.dart';

class WindowTitleBar extends Row {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const WindowTitleBar({required this.scaffoldKey, super.key});

  @override
  List<Widget> get children => [
        Expanded(
            child: WindowDragArea(
          maximizable: true,
          child: Row(children: [
            IconButton(
                iconSize: 24,
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  scaffoldKey.currentState!.openDrawer();
                }),
            const Expanded(
              child: Text("ETA Regulator Board Admin", textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(0xff, 0x57, 0x22, 1), fontSize: 24)),
            ),
            IconButton(
                iconSize: 24,
                icon: const Icon(Icons.close),
                onPressed: () async {
                  await windowManager.close();
                }),
          ]),
        )),
      ];
}
