import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/auth_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/auth_user_model.dart';
import 'package:eta_regulator_board_admin_toolbox/pages/login_page.dart';
import 'package:flutter/material.dart';

class RefreshTokenInterceptor extends InterceptorsWrapper {
  final Dio httpClient;

  RefreshTokenInterceptor(this.httpClient);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (App.authUser != null) {
      options.headers = {...options.headers, 'Authorization': 'Bearer ${App.authUser!.token}'};
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {

    if (err.response?.statusCode == 401) {
      if (App.authUser != null) {
        var newAuthUser = AuthUserModel.of(App.authUser!);
        App.unauthorize();
        try {
          var response = await httpClient.get('${AuthRepository.endPoint}/refresh-token', data: newAuthUser.toJson());
          if (response.statusCode == 200) {
            App.authUser = AuthUserModel.fromJson(response.data);
          }
        } on DioException catch (e) {
          if (e.response!.statusCode == 403) {
            globalNavigatorKey.currentState!
                .pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
            App.unauthorize();
          }
        }

        err.requestOptions.headers = {...httpClient.options.headers, 'Authorization': 'Bearer ${App.authUser!.token}'};

        return handler.resolve(await httpClient.fetch(err.requestOptions));
      }
    }

    super.onError(err, handler);
  }
}
