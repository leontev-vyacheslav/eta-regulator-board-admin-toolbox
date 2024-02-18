import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/foundation.dart';

class AppRepository {
  @protected
  Dio getHttpClient() {
    var httpClient = Dio();
    var baseUrl = 'http://localhost:5020'; // http://eta24/ru:15020';

    if (kDebugMode) {
      if (PlatformInfo.isDesktopOS) {
        baseUrl = 'http://localhost:5020';
      } else if (Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:5020';
      }
    }
    httpClient.options.baseUrl = baseUrl;

    return httpClient;
  }
}
