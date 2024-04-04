import 'dart:convert';

import 'package:http/http.dart' as http;

final GeneralApiService httpService = GeneralApiService();

class GeneralApiService {
  final JsonDecoder _decoder = const JsonDecoder();
  final JsonEncoder _encoder = const JsonEncoder();

  Map<String, String> headers = {"Content-Type": "application/json"};
  Map<String, String> urlEncodedHeaders = {
    "Content-Type": "application/x-www-form-urlencoded"
  };

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
    //print(headers);
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

  Future<dynamic> postURLEncoded(String url, {body, encoding}) {
    String msg = body == null ? "{}" : _encoder.convert(body);
    // print(msg);
    //print(urlEncodedHeaders);
    return http
        .post(Uri.parse(url),
            body: msg, headers: urlEncodedHeaders, encoding: encoding)
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

  Future<dynamic> put(String url, {body, encoding}) {
    return http
        .put(Uri.parse(url),
            body: _encoder.convert(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> postForm(String url,
      {Map<String, dynamic>? body,
      headers,
      List<http.MultipartFile?>? s,
      encoding}) async {
    print("POST $url with body $body and headers $headers");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    )..headers.addAll(headers);
    if (body != null) {
      for (var key in body.keys) {
        request.fields[key] = body[key].toString();
      }
    }
    if (s != null) {
      for (var e in s) {
        if (e != null) {
          request.files.add(e);
        }
      }
    }
    var streamedResponse = await request.send();
    var result = await http.Response.fromStream(streamedResponse);

    final String res = utf8.decode(result.bodyBytes);
    final int statusCode = result.statusCode;

    if (statusCode < 200 || statusCode > 400) {
      print(statusCode);
      print("Response body: $res");
      throw Exception("Error while fetching data");
    }
    return _decoder.convert(res);
  }
}
