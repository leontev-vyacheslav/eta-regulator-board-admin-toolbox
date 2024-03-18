import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/data_access/app_repository.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:eta_regulator_board_admin_toolbox/models/downloaded_file.dart';
import 'package:flutter/foundation.dart';

class BackupRepository {
  static const String endPoint = '/backups';

  final Dio httpClient = getIt<AppHttpClientFactory>().httpClient;

  Future<DownloadedFile?> get() async {
    var response = await httpClient.get(
      '${BackupRepository.endPoint}/',
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
