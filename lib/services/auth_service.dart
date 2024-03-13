import 'dart:core';
import 'dart:core';

import 'package:momentum/momentum.dart';

import '../controllers/login_controller.dart';
import '../controllers/register_controller.dart';
import '../models/location_model.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';
import '../utils/global.dart';
import 'general_api_service.dart';

class AuthServices extends MomentumService {
  Future<AuthResponse> login(LoginModel requestModel) async {
    String url = "$serverURL/login";
    // print(requestModel.toJson());
    try {
      final response = await httpService.post(url, body: requestModel.toJson());
      AuthResponse ss = AuthResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("Login response: $response");
      print("AuthResponse: ${parsedResponse.userName}");
      return parsedResponse;
    } on Exception catch (e) {
      print("login error: $e");
      return AuthResponse(
        AuthResponseController(),
        isAuthSuccessful: false,
        authResponseMessage: e.toString(),
      );
    }
  }

  Future<AuthRegisterResponse> register(RegisterModel requestModel) async {
    String url = "$serverURL/registerAccount";
    print("service Register" + requestModel.toJson().toString());
    // try {
    //   final response = await httpService.post(url, body: requestModel.toJson());
    //   AuthRegisterResponse ss = AuthRegisterResponseController().init();
    //   final parsedResponse = ss.fromJson(response);
    //   print("Register response: $response");
    //   print("AuthResponse: ${parsedResponse.authResponseMessage}");
    //   return parsedResponse;
    // } on Exception catch (e) {
    //   print("Register error: $e");
    //   return AuthRegisterResponse(
    //     AuthRegisterResponseController(),
    //     isAuthSuccessful: false,
    //     authResponseMessage: e.toString(),
    //   );
    // }
    final response = await httpService.post(url, body: requestModel.toJson());
    AuthRegisterResponse ss = AuthRegisterResponseController().init();
    final parsedResponse = ss.fromJson(response);
    print("Register response: $response");
    print("AuthResponse: ${parsedResponse.authResponseMessage}");
    return parsedResponse;
  }

  Future<AuthRegisterResponse> sendFCMToken(
      String token, String parentId) async {
    String url = "$serverURL/addTokenDevice";
    print("token:  $token - parentId: $parentId");
    try {
      final response = await httpService
          .post(url, body: {"parentId": parentId, "tokenDevice": token});
      AuthRegisterResponse ss = AuthRegisterResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("sendFCMToken response: $response");
      print(
          "AuthResponse of sendFCMToken: ${parsedResponse.authResponseMessage}");
      return parsedResponse;
    } on Exception catch (e) {
      print("Register error: $e");
      return AuthRegisterResponse(
        AuthRegisterResponseController(),
        isAuthSuccessful: false,
        authResponseMessage: e.toString(),
      );
    }
  }

  Future<AuthRegisterResponse> sendGPS(
      int busId, String latitude, String longitude) async {
    String url = "$serverURL/sendGPS";
    print("busId:  $busId - latitude: $latitude -  longitude: $longitude");
    try {
      final response = await httpService.post(url,
          body: {"busId": busId, "latitude": latitude, "longitude": longitude});
      AuthRegisterResponse ss = AuthRegisterResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("sendGPS response: $response");
      print("AuthResponse of sendGPS: ${parsedResponse.authResponseMessage}");
      return parsedResponse;
    } on Exception catch (e) {
      print("sendGPS error: $e");
      return AuthRegisterResponse(
        AuthRegisterResponseController(),
        isAuthSuccessful: false,
        authResponseMessage: e.toString(),
      );
    }
  }

  Future<Location> getGPSByParentId(String parentId) async {
    String url = "$serverURL/getGPSByParentId";
    try {
      final response = await httpService.post(url, body: {
        "parentId": parentId,
      });
      Location ss = const Location(lat: "0", long: "0");
      final parsedResponse = ss.fromJson(response);
      print("getGPS response: $response");
      return parsedResponse;
    } on Exception catch (e) {
      print("getGPS error: $e");
      return const Location(lat: "0", long: "0");
    }
  }

  Future<AuthRegisterResponse> sendRequestRegisterStudent(
      int deviceId, String studentId) async {
    String url = "$serverURL/registerId";
    print("deviceId:  $deviceId - studentId: $studentId ");
    try {
      final response = await httpService
          .post(url, body: {"deviceId": deviceId, "studentId": studentId});
      AuthRegisterResponse ss = AuthRegisterResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("sendRequestRegisterStudent response: $response");
      print(
          "AuthResponse of sendRequestRegisterStudent: ${parsedResponse.authResponseMessage}");
      return parsedResponse;
    } on Exception catch (e) {
      print("sendRequestRegisterStudent error: $e");
      return AuthRegisterResponse(
        AuthRegisterResponseController(),
        isAuthSuccessful: false,
        authResponseMessage: e.toString(),
      );
    }
  }
}
