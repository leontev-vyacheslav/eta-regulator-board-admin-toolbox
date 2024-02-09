import 'package:flutter/material.dart';

class AppDrawerHeader extends SizedBox {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawerHeader({required this.scaffoldKey, super.key});

  @override
  double? get height => 96.0;

  @override
  Widget? get child => DrawerHeader(
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            Image.asset('assets/images/icon.ico'),
            const SizedBox(
              width: 20,
            ),
            const Expanded(child: Text('ETA24™', style: TextStyle(color: Color.fromRGBO(0xff, 0x57, 0x22, 1)))),
            IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.closeDrawer();
                },
                icon: const Icon(Icons.close))
          ],
        ),
      );
}
