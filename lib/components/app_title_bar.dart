import 'package:eta_regulator_board_admin_toolbox/components/window_drag_area.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/dialogs/app_exit_dialog.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTitleBar extends StatelessWidget {
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;

  final bool isShowMenu;

  const AppTitleBar({required this.scaffoldKey, super.key, required this.context, required this.isShowMenu});

  Widget _getAppBarRow() {
    return Padding(
      padding: PlatformInfo.isDesktopOS() ? const EdgeInsets.fromLTRB(10, 10, 20, 10) : const EdgeInsets.only(top: 20),
      child: Row(children: [
        isShowMenu
            ? IconButton(
                iconSize: 32,
                icon: const Icon(Icons.menu),
                onPressed: () async {
                  scaffoldKey.currentState!.openDrawer();
                })
            : const SizedBox.shrink(),
        Expanded(
          child: Text(AppConsts.appTitle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textAccent,
                fontSize: PlatformInfo.isDesktopOS() ? 22 : 16,
              )),
        ),
        PlatformInfo.isDesktopOS()
            ? IconButton(
                iconSize: 32,
                icon: const Icon(Icons.close),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AppExitDialog(context: context);
                      });
                })
            : Container(),
      ]),
    );
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
