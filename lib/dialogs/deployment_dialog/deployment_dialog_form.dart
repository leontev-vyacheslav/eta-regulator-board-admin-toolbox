import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/components/popup_menu_item_divider.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/deployment_package_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:core';
import 'package:html/parser.dart';
import 'package:collection/collection.dart';

import '../../models/device_web_apps.dart';

class DeploymentDialogForm extends StatefulWidget {
  final RegulatorDeviceModel device;
  final BuildContext context;

  const DeploymentDialogForm({
    super.key,
    required this.context,
    required this.device,
  });

  @override
  State<StatefulWidget> createState() => _DeploymentDialogFormState();
}

class _DeploymentDialogFormState extends State<DeploymentDialogForm> {
  RegulatorDeviceModel? _device;
  Process? _process;
  bool _menuEnable = true;
  bool _isDeploymentProcessActive = false;

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _textFieldScrollController = ScrollController();
  final String _deploymentPath = kDebugMode ? 'assets/deployment' : 'data/flutter_assets/assets/deployment';

  @override
  void initState() {
    _device = widget.device;
    _checkConnection();
    super.initState();
  }

  Widget buildPopupMenu() {
    return Row(
      children: [
        Expanded(
            child: Text(
          'Deployment log of "${_device!.name}" device:',
        )),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _updateDeployment(DeviceWebApps.webApi);
                  await _updateDeployment(DeviceWebApps.webUi);
                },
                child: const Row(children: [
                  Icon(Icons.system_update),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Update deployments')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _checkConnection();
                },
                child: const Row(children: [
                  Icon(Icons.wifi),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Check connection')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _deploy(DeviceWebApps.webUi);
                },
                child: const Row(children: [
                  Icon(Icons.web_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Deploy Web UI')
                ]),
              ),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _deploy(DeviceWebApps.webApi);
                },
                child: const Row(children: [
                  Icon(Icons.api_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Deploy Web API')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: _menuEnable,
                onTap: () async {
                  await _deploy(DeviceWebApps.webApi);

                  Timer.periodic(const Duration(seconds: 1), (timer) async {
                    if (!_isDeploymentProcessActive) {
                      timer.cancel();
                      await _deploy(DeviceWebApps.webUi, clearLog: false, checkConnection: false);
                    }
                  });
                },
                child: const Row(children: [
                  Icon(Icons.install_desktop_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Deploy all')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                enabled: !_menuEnable,
                onTap: () {
                  _stopScriptProcess();
                },
                child: const Row(children: [
                  Icon(Icons.back_hand_outlined),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Stop deployment')
                ]),
              ),
              const PopupMenuItemDivider(),
              PopupMenuItem(
                // enabled: _menuEnable,
                onTap: () async {
                  await _checkDeploy(
                    webApp: DeviceWebApps.webApi,
                  );
                  await _checkDeploy(webApp: DeviceWebApps.webUi, clearLog: false);
                },
                child: const Row(children: [
                  Icon(Icons.checklist),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Check deployment')
                ]),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            buildPopupMenu(),
            SizedBox(
              width: 640,
              height: 200,
              child: TextField(
                decoration: InputDecoration(fillColor: Theme.of(widget.context).primaryColor, filled: true),
                style: TextStyle(
                    fontFamily: 'Consolas',
                    fontSize: 14,
                    backgroundColor: Theme.of(widget.context).primaryColor,
                    color: Colors.white70),
                controller: _textEditingController,
                scrollController: _textFieldScrollController,
                maxLines: null, // Set this
                expands: true, // and this
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _stdStreamListener(String text) {
    text = text.replaceAll(RegExp('\x1b[[0-9;]*m'), '');
    _textEditingController.text += text;
    _textFieldScrollController.jumpTo(_textFieldScrollController.position.maxScrollExtent);

    if (text.contains('Booting worker with pid')) {
      _stopScriptProcess();
    }
  }

  Map<String, Object>? _getLastDistributable(String appName) {
    var distributableDir = Directory('$_deploymentPath/distro');

    var distroFoldersInfo =
        distributableDir.listSync().where((d) => d.path.contains(appName)).map((d) {
      var folderName = basenameWithoutExtension(d.path);
      return {'name': folderName, 'date': DateTime.parse(folderName.split('_').last)};
    }).sortedBy((element) => element.keys.first);

    if (distroFoldersInfo.isNotEmpty) {
      return distroFoldersInfo.last;
    }

    return null;
  }

  void _stopScriptProcess() {
    if (_process != null) {
      _process!.kill();
      _process = null;
      _isDeploymentProcessActive = false;
    }
  }

  Future<void> _startScriptProcess(DeviceWebApps webApp, List<String> args, {bool clearLog = true}) async {
    if (_process != null) {
      _process!.kill();
      _process = null;
    }

    if (clearLog) {
      _textEditingController.text = '';
    }

    _process = await Process.start(
      'pwsh.exe',
      args,
    );

    setState(() {
      _menuEnable = false;
      _isDeploymentProcessActive = true;
    });

    _process!.stdout.transform(utf8.decoder).listen(_stdStreamListener);
    _process!.stderr.transform(utf8.decoder).listen(_stdStreamListener);

    _process!.exitCode.then((value) {
      setState(() {
        _menuEnable = true;
        _isDeploymentProcessActive = false;
        _process = null;
      });
    });
  }

  Future<void> _checkConnection() async {
    await _startScriptProcess(
        DeviceWebApps.webAny, ['$_deploymentPath/check_connection.ps1', '-ipaddr', _device!.name]);
  }

  Future<void> _checkDeploy({DeviceWebApps webApp = DeviceWebApps.webApi, bool clearLog = true}) async {
    var webAppPort = webApp == DeviceWebApps.webApi ? AppConsts.webApiPort : AppConsts.webUiPort;
    var webAppTitle = webApp == DeviceWebApps.webApi ? AppConsts.webApiTitle : AppConsts.webUiTitle;
    var isFound = false;
    var webResponseMessage = '';
    var toastMessage = 'The deployment of $webAppTitle was not found!';

    if (clearLog) {
      _textEditingController.clear();
      _textEditingController.text += 'The deploy verification on progress...\n';
    }

    var httpClient = Dio();
    try {
      var webApiResponse = await httpClient.get('http://${widget.device.name}:$webAppPort');

      if (webApiResponse.statusCode == 200) {
        var response = webApiResponse.data;
        if (webApp == DeviceWebApps.webApi) {
          webResponseMessage = (response["message"].toString());
          isFound = webResponseMessage.contains(webAppTitle);
        } else {
          var document = parse(response);
          var metaDescription = document.querySelector('meta[name="description"]')!.attributes['content'];
          if (metaDescription != null) {
            webResponseMessage = metaDescription;
            isFound = webResponseMessage.contains(webAppTitle);
          }
        }
      }
    } catch (e) {
      _textEditingController.text += '${AppStrings.messageVerificationFailed}\n';
      _textEditingController.text += 'An error was happened. An exception details: $e.\n`';

      toastMessage = 'The deploy verification of $webAppTitle was failed with an error!';
    }

    if (isFound) {
      var webApiVersion = webResponseMessage.replaceAll(webAppTitle, '').trim();
      _textEditingController.text += '$webAppTitle was successfully found.\n';
      _textEditingController.text += 'Its version is $webApiVersion!\n';
      toastMessage = 'The deploy verification of $webAppTitle was successful!';
    } else {
      _textEditingController.text += '${AppStrings.messageVerificationFailed}\n';
    }

    AppToast.show(widget.context, isFound ? ToastTypes.success : ToastTypes.error, toastMessage,
        duration: const Duration(seconds: 5));
  }

  Future<void> _deploy(DeviceWebApps webApp, {bool clearLog = true, bool checkConnection = true}) async {
    var appName = webApp == DeviceWebApps.webApi ? 'web_api' : 'web_ui';
    var distroFolder = _getLastDistributable(appName);
    if (distroFolder == null) {
      AppToast.show(widget.context, ToastTypes.warning, AppStrings.messageDeploymentPackageNotFound,
          duration: const Duration(seconds: 5));

      _textEditingController.clear();
      _textEditingController.text += AppStrings.messageDeploymentPackageNotFound;

      return;
    }

    var args = [
      '$_deploymentPath/deploy_$appName.ps1',
      '-ipaddr',
      _device!.name,
      '-root',
      _deploymentPath,
      '-distro',
      distroFolder.entries.first.value as String,
      '-masterKey',
      _device!.masterKey,
    ];

    if (checkConnection) {
      args.addAll(['-checkConnection', '\$True']);
    } else {
      args.addAll(['-checkConnection', '\$False']);
    }

    _startScriptProcess(webApp, args, clearLog: clearLog);
  }

  Future<void> _updateDeployment(DeviceWebApps webApp) async {
    var repository = getIt<DeploymentPackageRepository>();
    var appName = "${webApp == DeviceWebApps.webApi ? "web API" : "web UI"} application";
    var downloadedFile = await repository.downloadDeploymentPackage(webApp);
    if (downloadedFile != null) {
      var basePath = '$_deploymentPath/distro/${basenameWithoutExtension(downloadedFile.fileName)}';

      if (await Directory(basePath).exists()) {
        AppToast.show(widget.context, ToastTypes.warning, 'The latest version of $appName is available already.',
            duration: const Duration(seconds: 5));

        return;
      }

      var archive = ZipDecoder().decodeBytes(downloadedFile.buffer);
      extractArchiveToDisk(archive, basePath);

      AppToast.show(
          widget.context, ToastTypes.success, 'The deployment package of $appName was successfully unzipped.');
    } else {
      AppToast.show(widget.context, ToastTypes.warning, 'The deployment package of $appName was not found.',
          duration: const Duration(seconds: 5));
    }
  }
}
