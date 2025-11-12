import 'package:core/src/result/result.dart';
import 'package:dio/dio.dart';

Failure mapDioErrorToFailure(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout) {
    return Failure('Connection timed out', code: 408);
  }

  if (error.response != null) {
    final status = error.response?.statusCode ?? 500;
    final data = error.response?.data;
    final message = (data is Map && data['message'] != null)
        ? data['message'].toString()
        : error.message;
    return Failure(message ?? "ERROR", code: status);
  }

  return Failure(error.message ?? 'Unknown network error', code: 500);
}
