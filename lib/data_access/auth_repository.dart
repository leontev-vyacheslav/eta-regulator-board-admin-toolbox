import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/app_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';

import '../models/auth_user_model.dart';
import '../models/sign_in_model.dart';

class AuthRepository {
  static const String endPoint = '/auth';

  final Dio httpClient = getIt<AppHttpClientFactory>().httpClient;

  Future<AuthUserModel?> signIn(SignInModel singIn) async {
    try {
      var response = await httpClient.get('${AuthRepository.endPoint}/sign-in', data: singIn.toJson());
      if (response.statusCode == 200) {
        return AuthUserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
