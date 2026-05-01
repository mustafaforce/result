class RequestFailure implements Exception {
  const RequestFailure(this.message);

  final String message;
}
