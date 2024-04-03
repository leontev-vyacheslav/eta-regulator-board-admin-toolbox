import 'package:dio/dio.dart';
import 'package:eta_regulator_board_admin_toolbox/main.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    globalNavigatorKey.currentContext!.loaderOverlay.show();
    await Future.delayed(const Duration(milliseconds: 125));

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    await Future.delayed(const Duration(milliseconds: 125));
    if (globalNavigatorKey.currentContext!.loaderOverlay.visible) {
      globalNavigatorKey.currentContext!.loaderOverlay.hide();
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (globalNavigatorKey.currentContext!.loaderOverlay.visible) {
      globalNavigatorKey.currentContext!.loaderOverlay.hide();
    }

    super.onError(err, handler);
  }
}
