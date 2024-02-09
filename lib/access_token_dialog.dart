import 'package:flutter/material.dart';

class AccessTokenDialog extends AlertDialog {
  final BuildContext context;

  @override
  EdgeInsetsGeometry? get titlePadding => const EdgeInsets.fromLTRB(20, 15, 20, 15);

  const AccessTokenDialog({super.key, required this.context});

  @override
  Widget get title => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(child: Text('Create access token')),
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );

  @override
  get shape => const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)));

  @override
  List<Widget> get actions => [
        ElevatedButton.icon(
          label: const Text('OK'),
          onPressed: () {
            debugPrint('test');
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          icon: const Icon(Icons.close),
        )
      ];

  @override
  Widget get content => const SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Custom Content')],
        ),
      );
}
