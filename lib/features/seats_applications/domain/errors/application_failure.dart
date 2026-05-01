class ApplicationFailure implements Exception {
  const ApplicationFailure(this.message);

  final String message;
}
