import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/app_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/device_web_apps.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class DownloadedFile {
  final List<int> buffer;
  final String fileName;

  DownloadedFile({required this.buffer, required this.fileName});
}

class DeploymentPackageRepository {
  static const String endPoint = '/deployments';

  final Dio httpClient = getIt<AppHttpClientFactory>().httpClient;

  Future<void> uploadDeploymentPackage(List<int> buffer, String fileName) async {
    FormData formData = FormData.fromMap(
        {'file': MultipartFile.fromBytes(buffer, filename: fileName, contentType: MediaType.parse("application/zip"))});

    await httpClient.post('${DeploymentPackageRepository.endPoint}/', data: formData);
  }

  Future<DownloadedFile?> downloadDeploymentPackage(DeviceWebApps webApp) async {
    var appPrefix = webApp == DeviceWebApps.webApi ? 'api' : 'ui';
    var response = await httpClient.get(
      '${DeploymentPackageRepository.endPoint}/?web_app=$appPrefix',
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    if (response.statusCode == 200) {
      var fileName = '';
      var contentDisposition = response.headers['content-disposition'];
      if (contentDisposition != null) {
        fileName = contentDisposition.first.split('filename=').last.replaceAll('"', '');
      } else {
        return null;
      }

      return DownloadedFile(buffer: response.data as Uint8List, fileName: fileName);
    }

    return null;
  }
}
