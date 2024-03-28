import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/app.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/auth_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/auth_user_model.dart';
import 'package:eta_regulator_board_admin_toolbox/pages/login_page.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

String productionBaseUrl = 'http://eta24.ru:15020';
String debugLocalBaseUrl = 'http://127.0.0.1:5020';
String debugEmulatorLocalBaseUrl = 'http://10.0.2.2:5020';

class AppHttpClientFactory {
  Dio httpClient = Dio();

  AppHttpClientFactory() {
    var baseUrl = productionBaseUrl;
    // debugLocalBaseUrl = productionBaseUrl;

    if (kDebugMode) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (PlatformInfo.isDesktopOS() || kIsWeb) {
        baseUrl = debugLocalBaseUrl;
      } else if (!kIsWeb && Platform.isAndroid) {
        deviceInfo.androidInfo.then((androidInfo) {
          baseUrl = androidInfo.isPhysicalDevice ? productionBaseUrl : debugLocalBaseUrl;
        });
      }
    }
    httpClient.options.baseUrl = baseUrl;

    httpClient.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (App.authUser != null) {
          httpClient.options.headers = {
            ...httpClient.options.headers,
            'Authorization': 'Bearer ${App.authUser!.token}'
          };
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          if (App.authUser != null) {
            var newAuthUser = AuthUserModel.of(App.authUser!) ;
            App.unauthorize();

            try {
              var response =
                  await httpClient.get('${AuthRepository.endPoint}/refresh-token', data: newAuthUser.toJson());
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

            e.requestOptions.headers = {
              ...httpClient.options.headers,
              'Authorization': 'Bearer ${App.authUser!.token}'
            };

            return handler.resolve(await httpClient.fetch(e.requestOptions));
          }
        }
        return handler.next(e);
      },
    ));
  }
}
