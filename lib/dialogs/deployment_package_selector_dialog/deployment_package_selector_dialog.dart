import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_base_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/models/dialog_result.dart';
import 'package:eta_regulator_board_admin_toolbox/models/distro_folder__info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class DeploymentPackageSelectorForm extends StatefulWidget {
  final Key? formKey;
  final List<DistroFolderInfo> deploymentPackageList;

  const DeploymentPackageSelectorForm({super.key, this.formKey, required this.deploymentPackageList});

  @override
  State<StatefulWidget> createState() => _DeploymentPackageSelectorFormState();
}

class _DeploymentPackageSelectorFormState extends State<DeploymentPackageSelectorForm> {
  Key? _formKey;
  DistroFolderInfo? _dropdownValue;

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
            child: FormBuilder(
                key: _formKey,
                child: SizedBox(
                  width: 480,
                  child: FormBuilderDropdown(
                    isExpanded: true,
                    name: 'packageName',
                    enabled: widget.deploymentPackageList.isNotEmpty,
                    initialValue: _dropdownValue,
                    items: widget.deploymentPackageList.map((DistroFolderInfo value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.web_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(value.name)
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ))));
  }
}

class DeploymentPackageSelectorDialog extends AppBaseDialog {
  final List<DistroFolderInfo> deploymentPackageList;
  final _formKey = GlobalKey<FormBuilderState>();

  DeploymentPackageSelectorDialog(
      {super.key, required super.context, super.titleText='Package selector', required this.deploymentPackageList});

  @override
  Widget? get content => DeploymentPackageSelectorForm(deploymentPackageList: deploymentPackageList, formKey: _formKey);

  @override
  List<Widget>? get actions => [
        AppElevatedButton(
            onPressed: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                var value = _formKey.currentState!.value;

                Navigator.pop<DialogResult<DistroFolderInfo?>>(
                    context, DialogResult<DistroFolderInfo?>(result: ModalResults.ok, value: value['packageName']));
              }
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonOk,
              icon: Icons.check,
              color: AppColors.textAccent,
            )),
        AppElevatedButton(
            onPressed: () {
              Navigator.pop<DialogResult>(context, DialogResult(result: ModalResults.cancel, value: null));
            },
            child: const AppElevatedButtonLabel(
              label: AppStrings.buttonCancel,
              icon: Icons.close,
            )),
      ];
}
