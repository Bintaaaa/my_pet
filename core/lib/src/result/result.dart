class Failure {
  final String message;
  final int? code;
  const Failure(this.message, {this.code});
  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class Result<T> {
  final T? _value;
  final Failure? _failure;
  const Result._(this._value, this._failure);
  const Result.ok(T value) : this._(value, null);
  const Result.err(Failure failure) : this._(null, failure);

  bool get isOk => _failure == null;
  bool get isErr => _failure != null;

  T get value {
    if (isErr) throw StateError('Result is error: $_failure');
    return _value as T;
  }

  Failure get failure {
    if (isOk) throw StateError('Result is ok: $_value');
    return _failure as Failure;
  }

  R when<R>({required R Function(T) ok, required R Function(Failure) err}) {
    return isOk ? ok(value) : err(failure);
  }
}
