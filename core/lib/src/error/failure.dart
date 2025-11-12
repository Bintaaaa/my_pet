class FailureResponse {
  final String message;
  final int? code;
  const FailureResponse({required this.message, this.code});
  @override
  String toString() => 'FailureResponse(code: $code, message: $message)';
}
