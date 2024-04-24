import 'dart:core';

import 'package:busmate/models/list_history_attendance_teacher_today_model.dart';
import 'package:busmate/models/save_attendance_history_response_model.dart';
import 'package:busmate/models/take_attendance_response_model.dart';
import 'package:momentum/momentum.dart';

import '../controllers/item_history_attendance_teacher_today_controller.dart';
import '../controllers/list_history_attendance_teacher_today_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/register_smart_tag_response_controller.dart';
import '../controllers/save_attendance_history_response_controller.dart';
import '../controllers/send_smart_tags_controller.dart';
import '../controllers/take_attendance_response_controller.dart';
import '../models/item_history_attendance_teacher_today_model.dart';
import '../models/location_model.dart';
import '../models/login_model.dart';
import '../models/manager_location_model.dart';
import '../models/register_model.dart';
import '../models/register_smart_tag_response_model.dart';
import '../models/send_smart_tags_response_model.dart';
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

  Future<LocationModel> getGPSByParentId(String parentId) async {
    String url = "$serverURL/getGPSByParentId";
    try {
      final response = await httpService.post(url, body: {
        "parentId": parentId,
      });
      LocationModel ss =
          const LocationModel(lat: "0", long: "0", isOnBusBySmartTag: false);
      final parsedResponse = ss.fromJson(response);
      print("getGPS response: $response");
      return parsedResponse;
    } on Exception catch (e) {
      print("getGPS error: $e");
      return const LocationModel(lat: "0", long: "0", isOnBusBySmartTag: false);
    }
  }

  Future<List<ManagerLocationModel>> getGPSByUserId() async {
    String url = "$serverURL/getGPSByUserId";
    try {
      final response = await httpService.get(url);
      print("getGPSByUserId" + response.toString());
      return (response as List)
          .map((e) => ManagerLocationModel.fromJson(e))
          .toList();
    } on Exception catch (e) {
      print("getGPS error: $e");
      return [];
    }
  }

  Future<SaveAttendanceHistoryResponse> saveAttendanceHistoryReport(
      String suId, int busId) async {
    String url = "$serverURL/saveBusAttendanceReport";
    try {
      final response =
          await httpService.post(url, body: {"suId": suId, "busId": busId});
      SaveAttendanceHistoryResponse ss =
          SaveAttendanceHistoryResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("saveAttendanceHistoryReport response: $response");
      print(
          "Response of saveAttendanceHistoryReport: ${parsedResponse.responseMessage}");
      return parsedResponse;
    } on Exception catch (e) {
      print("saveAttendanceHistoryReport error: $e");
      return SaveAttendanceHistoryResponse(
        SaveAttendanceHistoryResponseController(),
        isSuccessful: false,
        responseMessage: e.toString(),
      );
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

  Future<RegisterSmartTagResponse> sendRegisterSmartTagStudent(
      String smartTagId, String studentId) async {
    String url = "$serverURL/registerSmartTag";
    print("smartTagId:$smartTagId - studentId:$studentId ");
    try {
      final response = await httpService
          .post(url, body: {"studentId": studentId, "smartTagId": smartTagId});
      RegisterSmartTagResponse ss = RegisterSmartTagResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("sendRegisterSmartTagStudent response: $response");
      return parsedResponse;
    } on Exception catch (e) {
      print("sendRequestRegisterStudent error: $e");
      return RegisterSmartTagResponse(
        RegisterSmartTagResponseController(),
        isSuccessful: false,
        responseMessage: e.toString(),
      );
    }
  }

  Future<AuthRegisterResponse> sendRegisterBusStop(
      String studentId, String lat, String long) async {
    String url = "$serverURL/registerBusStop";
    print("service sendRegisterBusStop" + studentId + lat + long);
    try {
      final response = await httpService.post(url,
          body: {"studentId": studentId, "latitude": lat, "longitude": long});
      AuthRegisterResponse ss = AuthRegisterResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("sendRegisterBusStop response: $response");
      print(
          "AuthResponse of sendRegisterBusStop: ${parsedResponse.authResponseMessage}");
      return parsedResponse;
    } on Exception catch (e) {
      print("sendRegisterBusStop error: $e");
      return AuthRegisterResponse(
        AuthRegisterResponseController(),
        isAuthSuccessful: false,
        authResponseMessage: e.toString(),
      );
    }
  }

  Future<TakeAttendanceResponse> takeAttendance(List<String> studentIds) async {
    String url = "$serverURL/updateStudentsOnBus";
    print("studentIds :$studentIds ");
    try {
      final response =
          await httpService.post(url, body: {"studentIds": studentIds});
      TakeAttendanceResponse ss = TakeAttendanceResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("takeAttendance response: $response");
      return parsedResponse;
    } on Exception catch (e) {
      print("takeAttendance error: $e");
      return TakeAttendanceResponse(
        TakeAttendanceResponseController(),
        isSuccessful: false,
        responseMessage: e.toString(),
      );
    }
  }

  Future<SendSmartTagsResponse> sendSmartTags(
      int busId, List<String?> smartTagsId) async {
    String url = "$serverURL/updateIsOnBusBySmartTag";
    print("busId :$busId - smartTagsId: $smartTagsId ");
    try {
      final response = await httpService
          .post(url, body: {"busId": busId, "idTags": smartTagsId});
      SendSmartTagsResponse ss = SendSmartTagsResponseController().init();
      final parsedResponse = ss.fromJson(response);
      print("SendSmartTagsResponse : $response");
      return parsedResponse;
    } on Exception catch (e) {
      print("SendSmartTagsResponse error: $e");
      return SendSmartTagsResponse(
        SendSmartTagsResponseController(),
        isSuccessful: false,
        responseMessage: e.toString(),
      );
    }
  }

  Future<List<ItemHistoryAttendanceTeacherModel>> getBusAttendanceReport(
      String suId) async {
    String url = "$serverURL/getBusAttendanceReport";
    try {
      final response = await httpService.post(url, body: {
        "suId": suId,
      });
      ItemHistoryAttendanceTeacherModel model =
          ItemHistoryAttendanceTeacherController().init();
      return (response as List).map((e) => model.fromJson(e)).toList();
    } on Exception catch (e) {
      print("getGPS error: $e");
      return [];
    }
  }
}
