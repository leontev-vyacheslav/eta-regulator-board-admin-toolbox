import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/app_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:http_parser/http_parser.dart';

class DeploymentPackageRepository {
  static const String endPoint = '/deployments';

  final Dio httpClient = getIt<AppHttpClientFactory>().httpClient;

  Future<void> uploadDeploymentPackager(List<int> buffer, String fileName) async {
    FormData formData = FormData.fromMap(
        {'file': MultipartFile.fromBytes(buffer, filename: fileName, contentType: MediaType.parse("application/zip"))});

    await httpClient.post('${DeploymentPackageRepository.endPoint}/', data: formData);
  }
}
