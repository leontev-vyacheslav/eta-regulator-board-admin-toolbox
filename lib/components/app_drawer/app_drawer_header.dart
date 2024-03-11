import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';

class AppDrawerHeader extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawerHeader({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: DrawerHeader(
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            kIsWeb
                ? Image.asset(
                    'assets/images/favicon.png',
                    width: 55,
                    height: 55,
                  )
                : Image.asset(
                    'assets/images/icon.ico',
                  ),
            const SizedBox(
              width: 20,
            ),
            const Expanded(child: Text(AppConsts.companyTradeMark, style: TextStyle(color: AppColors.textAccent))),
            IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.closeDrawer();
                },
                icon: const Icon(Icons.close))
          ],
        ),
      ),
    );
  }
}
