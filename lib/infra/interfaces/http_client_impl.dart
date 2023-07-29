import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../domain/errors/errors.dart';
import '../../domain/interfaces/http_client.dart';
class HttpClientImpl implements HttpClientBase {
  @override
  Future<Either<HttpError, String>> get(String url,
      {Map<String, String>? headers, int timeout = 5000}) async {
    final uri = Uri.parse(url);
    var response = await http.get(uri, headers: headers)
      .timeout(Duration(milliseconds: timeout));
    if(response.statusCode >= HttpStatus.badRequest){
      return Left(HttpResponseError(response.statusCode, response.body));
    } else {
      return Right(response.body);
    }
  }

  @override
  Future<Either<HttpError, String>> post(String url, String data,
      {ContentType? contentType, Map<String, String>? headers, int timeout = 5000}) async {
    final uri = Uri.parse(url);

    headers ??= <String, String>{};
    headers[HttpHeaders.contentTypeHeader] = contentType?.value ?? ContentType.json.value;

    var response = await http.post(uri, headers: headers)
      .timeout(Duration(milliseconds: timeout));
    if(response.statusCode >= HttpStatus.badRequest){
      return Left(HttpResponseError(response.statusCode, response.body));
    } else {
      return Right(response.body);
    }
  }
}
