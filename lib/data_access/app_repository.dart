import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/utils/platform_info.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

String productionBaseUrl = 'http://eta24.ru:15020';
String debugLocalBaseUrl = 'http://192.168.0.107:5020';
String debugEmulatorLocalBaseUrl = 'http://10.0.2.2:5020';

class AppHttpClientFactory {
  Dio httpClient = Dio();

  AppHttpClientFactory() {
    var baseUrl = productionBaseUrl;
    debugLocalBaseUrl = productionBaseUrl;
    
    if (kDebugMode) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (PlatformInfo.isDesktopOS() || kIsWeb) {
        baseUrl = debugLocalBaseUrl;
      } else if (!kIsWeb && Platform.isAndroid) {
        deviceInfo.androidInfo.then((androidInfo) {
          baseUrl = androidInfo.isPhysicalDevice ? debugLocalBaseUrl : debugLocalBaseUrl;
        });
      }
    }
    httpClient.options.baseUrl = baseUrl;
  }
}
