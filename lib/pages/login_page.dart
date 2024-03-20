import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_elevated_button.dart';
import 'package:eta_regulator_board_admin_toolbox/components/app_title_bar.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_colors.dart';
import 'package:eta_regulator_board_admin_toolbox/constants/app_consts.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/auth_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/pages/home_page.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/toast_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';

import '../models/sign_in_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  final TextEditingController _loginTextController = TextEditingController(text: kDebugMode ? 'admin' : '');
  final TextEditingController _passwordTextController = TextEditingController(text: kDebugMode ? '12345678' : '');

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            toolbarHeight: 60,
            leading: Container(),
            title: PlatformInfo.isDesktopOS()
                ? AppTitleBar(
                    scaffoldKey: _scaffoldKey,
                    context: context,
                  )
                : Text(AppConsts.appTitle,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textAccent,
                      fontSize: PlatformInfo.isDesktopOS() ? 22 : 18,
                    ))),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: PlatformInfo.isDesktopOS()
                          ? const EdgeInsets.symmetric(vertical: 75, horizontal: 50)
                          : const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                      child: Column(
                        children: [
                          Wrap(runSpacing: 30, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/app-logo.svg',
                                  semanticsLabel: 'Acme Logo',
                                  width: 100,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                    child: Text('Welcome to ${AppConsts.companyTradeMark}',
                                        style: TextStyle(
                                          fontSize: PlatformInfo.isDesktopOS() ? 22 : 18,
                                        ))),
                              ],
                            ),
                            TextFormField(
                                controller: _loginTextController,
                                onSaved: (currentId) {},
                                decoration: const InputDecoration(
                                  icon: Icon(
                                    Icons.account_circle_outlined,
                                    size: 28,
                                  ),
                                  border: UnderlineInputBorder(),
                                  labelText: 'Login',
                                )),
                            TextFormField(
                                controller: _passwordTextController,
                                obscureText: _isObscure,
                                enableSuggestions: false,
                                autocorrect: false,
                                onSaved: (currentName) {
                                  if (currentName != null) {}
                                },
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.key_outlined),
                                  suffix: IconButton(
                                    style: const ButtonStyle(enableFeedback: false),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                  ),
                                  border: const UnderlineInputBorder(),
                                  labelText: 'Password',
                                ))
                          ]),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 75),
                            child: AppElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5))),
                                    padding: const EdgeInsets.fromLTRB(15, 15, 20, 15),
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(185, 55)),
                                onPressed: () async {
                                  _formKey.currentState!.save();
                                  var repository = getIt<AuthRepository>();

                                  var authUser = await repository.signIn(SignInModel(
                                      login: _loginTextController.text, password: _passwordTextController.text));
                                  if (authUser != null) {
                                    App.authUser = authUser;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const HomePage(title: AppConsts.appTitle)),
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
                                  label: '     Login      ',
                                  icon: Icons.login_outlined,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
