import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:flutter/material.dart';

class DeploymentPackageSelectorForm extends StatefulWidget {
  final Key? formKey;
  final List<String> deploymentPackageList;

  const DeploymentPackageSelectorForm({super.key, this.formKey, required this.deploymentPackageList});

  @override
  State<StatefulWidget> createState() => _DeploymentPackageSelectorFormState();
}

class _DeploymentPackageSelectorFormState extends State<DeploymentPackageSelectorForm> {
  Key? _formKey;
  String? _dropdownValue;

  @override
  void initState() {
    _formKey = widget.formKey;
    _dropdownValue = widget.deploymentPackageList.firstOrNull;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Form(
                key: _formKey,
                child: SizedBox(
                  width: 360,
                  child: DropdownMenu<String>(
                    width: 360,
                    enabled: widget.deploymentPackageList.isNotEmpty,
                    initialSelection: _dropdownValue,
                    dropdownMenuEntries: widget.deploymentPackageList.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                    onSelected: (String? value) {
                      setState(() {
                        _dropdownValue = value!;
                      });
                    },
                  ),
                ))));
  }
}

class DeploymentPackageSelectorDialog extends AppBaseDialog {
  final List<String> deploymentPackageList;
  final _formKey = GlobalKey<FormState>();

  DeploymentPackageSelectorDialog(
      {super.key, required super.context, required super.titleText, required this.deploymentPackageList});

  @override
  Widget? get content => DeploymentPackageSelectorForm(deploymentPackageList: deploymentPackageList, formKey: _formKey);

  @override
  List<Widget>? get actions => [
        AppElevatedButton(
            onPressed: () {
              Navigator.pop<DialogResult<String?>>(
                  context, DialogResult<String?>(result: ModalResults.ok, value: null));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonOk,
              icon: Icons.check,
              color: AppColors.textAccent,
            )),
        AppElevatedButton(
            onPressed: () {
              Navigator.pop<DialogResult<String?>>(
                  context, DialogResult<String?>(result: ModalResults.cancel, value: null));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonCancel,
              icon: Icons.close,
            )),
      ];
}
