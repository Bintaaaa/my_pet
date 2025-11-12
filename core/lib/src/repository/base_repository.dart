import '../result/result.dart';
import '../error/failure_mapper.dart';
import 'package:dio/dio.dart';
import '../network/network_helper.dart';

abstract class BaseRepository {
  final NetworkHelper networkHelper;
  BaseRepository(this.networkHelper);

  Future<Result<T>> safeApiCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Result.ok(result);
    } on DioException catch (e) {
      final f = mapDioErrorToFailure(e);
      return Result.err(f);
    } catch (e) {
      return Result.err(Failure(e.toString()));
    }
  }
}
