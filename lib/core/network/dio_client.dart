import 'package:dio/dio.dart';
import '../utils/app_logger.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio.options = BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i("🚀 API REQUEST: [${options.method}] => PATH: ${options.path}");
          if (options.data != null) {
            logger.d("📦 Body: ${options.data}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d("API RESPONSE: [${response.statusCode}] => FROM: ${response.requestOptions.path}");
          logger.v("Data received: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e("API ERROR: [${e.response?.statusCode}] => MESSAGE: ${e.message}");
          if (e.response?.data != null) {
            logger.w("💬 Error Details: ${e.response?.data}");
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}