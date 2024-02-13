import 'package:flutter/material.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_strings.dart';

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
            Image.asset('assets/images/icon.ico'),
            const SizedBox(
              width: 20,
            ),
            const Expanded(child: Text(AppStrings.companyTradeMark, style: TextStyle(color: AppColors.textAccent))),
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
