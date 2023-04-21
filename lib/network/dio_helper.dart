import 'package:dio/dio.dart';

import '../tool/log.dart';

var _dio;
var _noEncryptionDio;

Dio getDio() {
  if (_dio == null) {
    _dio = Dio();
    // _dio.interceptors.add(EncryptionAndDecryptionInterceptors());
    _dio.interceptors.add(DecryptionInterceptors());
    _dio.options = BaseOptions(
      baseUrl: "http://www.sancun.vip/",
      connectTimeout: Duration(milliseconds: 8000),
      receiveTimeout: Duration(milliseconds: 8000),
    );
  }
  return _dio;
}

//无加密Dio
Dio getNoEncryptionDio() {
  if (_noEncryptionDio == null) {
    _noEncryptionDio = Dio();
    _noEncryptionDio.interceptors.add(DecryptionInterceptors());
    _noEncryptionDio.options = BaseOptions(
      baseUrl: "http://www.sancun.vip",
      connectTimeout: Duration(milliseconds: 50000),
      sendTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 8000),
    );
  }
  return _noEncryptionDio;
}

class DecryptionInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
        '《===== REQUEST[${options.method}] => PATH: ${options.baseUrl}${options.path} '
            '=> body:${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
        '======》RESPONSE statusCode=[${response.statusCode}] => PATH: ${response.realUri}'
            '  =》body: ${response.toString()}');
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(
        'ERROR[${err.response}] => PATH: ${err.requestOptions.baseUrl}${err.requestOptions.path}');
    handler.next(err);
  }
}
