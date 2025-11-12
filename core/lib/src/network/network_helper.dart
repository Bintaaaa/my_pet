import 'dart:async';
import 'package:dio/dio.dart';
import '../logger/app_logger.dart';

class NetworkHelper {
  final Dio dio;
  final AppLogger logger;
  NetworkHelper._(this.dio, this.logger);

  factory NetworkHelper({
    required String baseUrl,
    AppLogger? logger,
    int connectTimeoutMs = 10000,
    int receiveTimeoutMs = 10000,
  }) {
    final d = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeoutMs),
      receiveTimeout: Duration(milliseconds: receiveTimeoutMs),
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json'},
    ));
    final log = logger ?? const AppLogger('NetworkHelper');
    d.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));
    return NetworkHelper._(d, log);
  }

  Future<Response<T>> safeRequest<T>(
      Future<Response<T>> Function() requestFn, {
        int maxRetry = 3,
        Duration initialBackoff = const Duration(milliseconds: 200),
      }) async {
    int attempt = 0;
    while (true) {
      try {
        final resp = await requestFn();
        return resp;
      } on DioException catch (e) {
        attempt++;
        logger.warn('Request failed attempt $attempt: ${e.message}');
        if (attempt >= maxRetry) rethrow;
        final backoff = initialBackoff * (1 << (attempt - 1));
        await Future.delayed(backoff);
        continue;
      }
    }
  }
}
