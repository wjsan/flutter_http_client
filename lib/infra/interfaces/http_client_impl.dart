import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../domain/errors/errors.dart';
import '../../domain/interfaces/http_client.dart';

class HttpClientImpl implements HttpClientBase {
  @override
  Future<Either<HttpError, String>> get(String url,
      {Map<String, String>? headers, int timeout = 5000}) async {
    final uri = Uri.parse(url);
    final client = HttpClient();

    client.idleTimeout = Duration(milliseconds: timeout);
    client.connectionTimeout = Duration(milliseconds: timeout);

    try {
      final request = await client.getUrl(uri);
      if (headers != null) {
        headers.forEach((key, value) => request.headers.add(key, value));
      }

      final result = await request.close();
      final resultBytes = await result
          .fold<List<int>>([], (bytes, chunk) => bytes..addAll(chunk));
      final response = utf8.decode(resultBytes);

      if (result.statusCode == HttpStatus.ok) {
        return Right(response);
      } else {
        return Left(HttpResponseError(result.statusCode));
      }
    } catch (e) {
      return Left(HttpRequestException(e));
    }
  }

  @override
  Future<Either<HttpError, String>> post(String url, String data,
      {ContentType? contentType, Map<String, String>? headers, int timeout = 5000}) async {
    final uri = Uri.parse(url);
    final client = HttpClient();

    client.idleTimeout = Duration(milliseconds: timeout);
    client.connectionTimeout = Duration(milliseconds: timeout);

    try {
      final request = await client.postUrl(uri);
      request.headers.contentType = contentType ?? ContentType.json;
      request.headers.contentLength = data.length;
      if (headers != null) {
        headers.forEach((key, value) => request.headers.add(key, value));
      }
      request.write(data);

      final result = await request.close();
      final resultBytes = await result
          .fold<List<int>>([], (bytes, chunk) => bytes..addAll(chunk));
      final response = utf8.decode(resultBytes);

      if (result.statusCode == HttpStatus.ok) {
        return Right(response);
      } else {
        return Left(HttpResponseError(result.statusCode));
      }
    } catch (e) {
      return Left(HttpRequestException(e));
    }
  }
}
