// import 'package:flutter/material.dart';
// import 'package:flutter_test_app/models/regulator_device_model.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// class RegulatorDeviceDialogForm extends StatefulWidget {
//   final RegulatorDeviceModel? device;

//   const RegulatorDeviceDialogForm({super.key, this.device});

//   @override
//   State<StatefulWidget> createState() => _RegulatorDeviceDialogFormState();
// }

// class _RegulatorDeviceDialogFormState extends State<RegulatorDeviceDialogForm> {
//   RegulatorDeviceModel? _device;

//   @override
//   void initState() {
//     _device = widget.device;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         width: 640,
//         child: Form(
//           child: Wrap(
//             runSpacing: 20,
//             children: [
//               TextFormField(
//                   initialValue: widget.device?.id,
//                   readOnly: widget.device != null,
//                   onChanged: (value) {},
//                   decoration: InputDecoration(
//                       border: const OutlineInputBorder(),
//                       labelText: 'Id',
//                       suffix: IconButton(
//                         style: const ButtonStyle(enableFeedback: false),
//                         onPressed: widget.device == null ? () {} : null,
//                         icon: const Icon(Icons.refresh),
//                       ))),
//               TextFormField(
//                 initialValue: widget.device?.name,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Device name',
//                 ),
//               ),
//               TextFormField(
//                 initialValue: widget.device?.macAddress,
//                 inputFormatters: [
//                   MaskTextInputFormatter(
//                       mask: '##:##:##:##:##:##',
//                       filter: {"#": RegExp(r'[0-9a-fA-F]')},
//                       type: MaskAutoCompletionType.lazy)
//                 ],
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'MAC address',
//                 ),
//               ),
//               TextFormField(
//                   initialValue: widget.device?.masterKey,
//                   decoration: InputDecoration(
//                       border: const OutlineInputBorder(),
//                       labelText: 'Master key',
//                       suffix: IconButton(
//                         style: const ButtonStyle(enableFeedback: false),
//                         onPressed: widget.device != null ? () {} : null,
//                         icon: const Icon(Icons.refresh),
//                       ))),
//             ],
//           ),
//         ));
//   }
// }
