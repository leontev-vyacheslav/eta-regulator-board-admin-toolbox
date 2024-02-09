import 'package:flutter/material.dart';

class RegulatorDeviceListTile extends ListTile {
  final String name;

  const RegulatorDeviceListTile({required this.name, super.key});

  @override
  Widget? get leading => const Icon(Icons.devices);

  @override
  Widget? get title => Text(name);

  @override
  Widget? get trailing => PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              child: Row(children: [
                Icon(Icons.edit),
                SizedBox(
                  width: 10,
                ),
                Text('Edit device')
              ]),
            ),
            const PopupMenuItem(
                height: 1,
                child: Divider(
                  height: 1,
                  thickness: 1,
                )),
            const PopupMenuItem(
                child: Row(children: [
              Icon(Icons.key),
              SizedBox(
                width: 10,
              ),
              Text('Create access token')
            ])),
          ];
        },
      );
}
