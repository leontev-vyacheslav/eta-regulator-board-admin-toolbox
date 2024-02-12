import 'package:flutter/material.dart';
import 'package:flutter_test_app/constants/app_colors.dart';
import 'package:flutter_test_app/constants/app_strings.dart';

class AppDrawerHeader extends SizedBox {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawerHeader({required this.scaffoldKey, super.key});

  @override
  double? get height => 96.0;

  @override
  Widget? get child => DrawerHeader(
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
      );
}
