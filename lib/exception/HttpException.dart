class HttpException implements Exception {
  String message = "";

  HttpException(this.message);

  @override
  String toString() {
    return 'HttpException{message: $message}';
  }
}
