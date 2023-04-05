import 'package:dartz/dartz.dart';
import '../errors/errors.dart';

abstract class HttpClientBase {
  Future<Either<HttpError, String>> post(String url, String data, {Map<String, String>? headers, int timeout = 5000});
  Future<Either<HttpError, String>> get(String url, {Map<String, String>? headers, int timeout = 5000});
}