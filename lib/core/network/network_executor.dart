import 'package:dio/dio.dart';
import 'api_failure.dart';

class NetworkExecutor {
  final Dio _dio;

  NetworkExecutor(this._dio);

  Future<dynamic> execute({
    required String url,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiFailure(
        e.response?.data['message'] ?? "Something went wrong",
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ApiFailure("Unexpected error occurred");
    }
  }
}