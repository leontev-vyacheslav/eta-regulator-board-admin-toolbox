import 'package:eta_regulator_board_admin_toolbox/models/access_token_model.dart';
import 'package:eta_regulator_board_admin_toolbox/models/regulator_device_model.dart';

import 'app_repository.dart';

class AccessTokenRepository extends AppRepository {
  static const String endPoint = '/access-token';

  Future<AccessTokenModel?> get(RegulatorDeviceModel device) async {
    AccessTokenModel? accessToken;

    var httpClient = getHttpClient();

    try {
      var response = await httpClient.get('${AccessTokenRepository.endPoint}/${device.id}');
      if (response.statusCode == 200) {
        accessToken = AccessTokenModel.fromJson(response.data);
      }
    } on Exception catch (e) {
      // ignore: avoid_print
      print('Exception details:\n $e');
    } finally {
      httpClient.close(force: true);
    }

    return accessToken;
  }
}
