import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppHttpClientFactory {
  Dio httpClient = Dio();

  AppHttpClientFactory() {
    // httpClient = Dio();
    var baseUrl = 'http://eta24/ru:15020';

    if (kDebugMode) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (PlatformInfo.isDesktopOS) {
        baseUrl = 'http://192.168.0.107:5020';
      } else if (Platform.isAndroid) {
        deviceInfo.androidInfo.then((androidInfo) {
          baseUrl = androidInfo.isPhysicalDevice ? 'http://192.168.0.107:5020' : 'http://192.168.0.107:5020';
        });
        // 'http://10.0.2.2:5020';
      }
    }
    httpClient.options.baseUrl = baseUrl;
  }
}

class AppRepository {
  @protected
  Future<Dio> getHttpClient() async {
    var httpClient = Dio();
    var baseUrl = 'http://eta24/ru:15020';

    if (kDebugMode) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (PlatformInfo.isDesktopOS) {
        baseUrl = 'http://192.168.0.107:5020';
      } else if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        baseUrl = androidInfo.isPhysicalDevice ? 'http://192.168.0.107:5020' : 'http://192.168.0.107:5020';
        // 'http://10.0.2.2:5020';
      }
    }
    httpClient.options.baseUrl = baseUrl;

    return httpClient;
  }
}
