import 'dart:convert';

import 'package:http/http.dart' as http;

final GeneralApiService httpService = GeneralApiService();

class GeneralApiService {
  final JsonDecoder _decoder = const JsonDecoder();
  final JsonEncoder _encoder = const JsonEncoder();

  Map<String, String> headers = {"Content-Type": "application/json"};

  Future<dynamic> get(String url, {headers}) {
    return http
        .get(Uri.parse(url), headers: headers)
        .then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes);
      final int statusCode = response.statusCode;

      if (statusCode == 200 || statusCode == 400) {
        return _decoder.convert(res);
      } else {
        print(statusCode);
        throw Exception("Error while fetching data");
      }
    });
  }

  Future<dynamic> post(String url, {body, encoding}) {
    String? msg = _encoder.convert(body);

    return http
        .post(Uri.parse(url), body: msg, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = utf8.decode(response.bodyBytes);

      final int statusCode = response.statusCode;

      if (statusCode == 200 ||
          statusCode == 400 ||
          statusCode == 401 ||
          statusCode == 201 ||
          statusCode == 500) {
        return _decoder.convert(res);
      } else {
        print(statusCode);
        throw Exception("Error while fetching data");
      }
    });
  }
}
