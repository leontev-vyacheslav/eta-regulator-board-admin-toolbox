import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/access_token_model.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';
import 'package:flutter/foundation.dart';

import 'app_repository.dart';

class AccessTokenRepository  {
  static const String endPoint = '/access-token';
  final Dio httpClient = getIt<AppHttpClientFactory>().httpClient;

  Future<AccessTokenModel?> get(RegulatorDeviceModel device, int duration) async {
    AccessTokenModel? accessToken;

    try {
      var response = await httpClient.get('${AccessTokenRepository.endPoint}/${device.id}?duration=$duration');
      if (response.statusCode == 200) {
        accessToken = AccessTokenModel.fromJson(response.data);
      }
    } on Exception catch (e) {
      debugPrint('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return accessToken;
  }
}
