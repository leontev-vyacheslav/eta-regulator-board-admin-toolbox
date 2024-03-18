import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_title_bar.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/auth_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/pages/home_page.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../models/sign_in_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _loginTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              AppTitleBar(
                scaffoldKey: _scaffoldKey,
                context: context,
                isShowMenu: false,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 150),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 640,
                        child: Wrap(runSpacing: 20, children: [
                          TextFormField(
                              controller: _loginTextController,
                              onSaved: (currentId) {},
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Login',
                              )),
                          TextFormField(
                              controller: _passwordTextController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              onSaved: (currentName) {
                                if (currentName != null) {}
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              )),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: AppElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                              padding: const EdgeInsets.fromLTRB(15, 15, 20, 15),
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              _formKey.currentState!.save();
                              var repository = getIt<AuthRepository>();

                              var authUser = await repository.signIn(SignInModel(
                                  login: _loginTextController.text, password: _passwordTextController.text));
                              if (authUser != null) {
                                App.authUser = authUser;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const HomePage(title: AppConsts.appTitle)),
                                );
                                AppToast.show(context, ToastTypes.success,
                                    'The user ${authUser.login} was successfully authorized.',
                                    duration: const Duration(seconds: 2));
                              } else {
                                AppToast.show(context, ToastTypes.warning,
                                    'The user ${_loginTextController.text} was not found or password was wrong.',
                                    duration: const Duration(seconds: 2));
                              }
                            },
                            child: const AppElevatedButtonLabel(
                              label: 'Login',
                              icon: Icons.login_outlined,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
