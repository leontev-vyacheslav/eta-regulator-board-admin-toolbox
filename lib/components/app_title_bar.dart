import 'package:eta_regulator_board_admin_toolbox/components/window_drag_area.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_exit_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTitleBar extends StatelessWidget {
  final BuildContext context;

  const AppTitleBar({super.key, required this.context});

  Widget _getAppBarRow() {
    return PlatformInfo.isDesktopOS()
        ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: Row(children: [
              Expanded(
                child: Text(AppConsts.appTitle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textAccent,
                      fontSize: PlatformInfo.isDesktopOS() ? 22 : 16,
                    )),
              ),
              IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AppExitDialog(context: context);
                        });
                  })
            ]),
          )
        : Text(AppConsts.appTitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textAccent,
              fontSize: PlatformInfo.isDesktopOS() ? 22 : 18,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: PlatformInfo.isDesktopOS()
                ? WindowDragArea(
                    maximizable: true,
                    child: _getAppBarRow(),
                  )
                : _getAppBarRow()),
      ],
    );
  }
}
