import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    _dio
      ..options.baseUrl = 'https://newsapi.org/v2/'
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10)
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      )); 
  }

  Dio get dio => _dio;
}