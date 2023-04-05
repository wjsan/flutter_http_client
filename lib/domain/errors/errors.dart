class HttpError implements Exception {}

class HttpRequestException implements HttpError {
  final Object exception;

  HttpRequestException(this.exception);
}

class HttpResponseError implements HttpError {
  final int statusCode;

  HttpResponseError(this.statusCode);
}
