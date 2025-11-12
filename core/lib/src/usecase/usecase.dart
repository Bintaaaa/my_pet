import '../result/result.dart';

abstract class UseCase<ReturnType, Params> {
  const UseCase();
  Future<Result<ReturnType>> call(Params params);
}

class NoParams {
  const NoParams();
}
